//
//  MainViewController.swift
//  VoiceTest
//
//  Created by imac-2626 on 2025/7/10.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var txfInstruction: UITextField!
    
    @IBOutlet var btnImplement: UIButton!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    @IBAction func btnImplement(_ sender: Any) {
        // 👉 取得輸入的文字並移除空白字元
        guard let command = txfInstruction.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        executeCommand(command)  // 👉 執行輸入的指令
    }
    
    
    // MARK: - Function
    /// 根據輸入的指令進行對應操作
    func executeCommand(_ command: String) {
        if command == "截圖" {
            takeScreenshot()  // 👉 如果輸入「截圖」，就執行截圖功能
        } else {
            print("❌ 尚未支援的指令：\(command)")  // 👉 其他指令目前尚未實作
        }
    }
    
    /// 擷取整個畫面並儲存到相簿
    func takeScreenshot() {
        guard let window = UIApplication.shared.windows.first else { return }  // 👉 取得目前顯示的主視窗
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        let image = renderer.image { context in
            window.layer.render(in: context.cgContext)  // 👉 渲染成圖片
        }
        
        // 👉 將 UIImage 轉為暫存的 PNG 檔案
        if let imageData = image.pngData() {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("screenshot.png")
            do {
                try imageData.write(to: tempURL)
                
                // 👉 用分享控制器詢問使用者儲存位置
                let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                present(activityVC, animated: true, completion: nil)
            } catch {
                print("❌ 儲存暫存檔失敗：\(error.localizedDescription)")
            }
        }
    }
    
    /// 儲存圖片後的回呼，用來處理成功與錯誤
    @objc func imageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if let error = error {
            print("❌ 儲存失敗：\(error.localizedDescription)")
            alert.title = "儲存失敗"
            alert.message = error.localizedDescription
        } else {
            print("✅ 成功儲存截圖到相簿！")
            alert.title = "成功"
            alert.message = "已將截圖儲存到相簿"
        }
        
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
// MARK: - Extensions

