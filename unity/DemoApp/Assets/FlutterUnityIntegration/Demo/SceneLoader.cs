using System.Collections;
using System.Collections.Generic;
using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.SceneManagement;

using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    // URL 指向服务器上的 AssetBundle 文件
    public string bundleUrl = "https://12123-1305727347.cos.ap-beijing.myqcloud.com/scene_2.bundle"; 
    public string sceneName = "scene_2"; // 替换为 AssetBundle 中的场景名称
    
    // Start is called before the first frame update
    void Start()
    {
        // mMessenger = new UnityMessageManager();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void LoadScene(int idx)
    {
        Debug.Log("scene = " + idx);
        if (idx == 0)
        {
            Debug.Log("scene = " + idx);
            SceneManager.LoadScene(idx, LoadSceneMode.Single);
        }
        else
        {
            StartCoroutine(LoadSceneCoroutine());
        }
    }

    private IEnumerator LoadSceneCoroutine()
    {
        Debug.Log($"Loading AssetBundle from: {bundleUrl}");

        // 下载 AssetBundle
        UnityWebRequest request = UnityWebRequestAssetBundle.GetAssetBundle(bundleUrl);
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError("Failed to download AssetBundle: " + request.error);
            yield break;
        }

        AssetBundle bundle = DownloadHandlerAssetBundle.GetContent(request);

        if (bundle == null)
        {
            Debug.LogError("Failed to load AssetBundle.");
            yield break;
        }

        // 检查 AssetBundle 是否包含场景
        if (bundle.isStreamedSceneAssetBundle)
        {
            string[] scenes = bundle.GetAllScenePaths();
            Debug.Log("Available scenes in AssetBundle: " + string.Join(", ", scenes));

            // 确保场景名称匹配
            if (System.Array.Exists(scenes, s => s.Contains(sceneName)))
            {
                Debug.Log($"Loading scene: {sceneName}");
                SceneManager.LoadScene(sceneName);
            }
            else
            {
                Debug.LogError($"Scene {sceneName} not found in AssetBundle.");
            }
        }
        else
        {
            Debug.LogError("AssetBundle does not contain a scene!");
        }

        // 卸载 AssetBundle（根据需求调整卸载选项）
        // bundle.Unload(false);
    }
    public void MessengerFlutter()
    {

        UnityMessageManager.Instance.SendMessageToFlutter("Hey man");
    }

    public void SwitchNative()
    {
        UnityMessageManager.Instance.ShowHostMainWindow();
    }

    public void UnloadNative()
    {
        UnityMessageManager.Instance.UnloadMainWindow();
    }

    public void QuitNative()
    {
        UnityMessageManager.Instance.QuitUnityWindow();
    }
}
