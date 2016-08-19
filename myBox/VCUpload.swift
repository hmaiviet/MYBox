//
//  VCUpload.swift
//  myBox
//
//  Created by VietHung on 8/13/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class VCUpload: UIViewController, UITableViewDelegate, UITableViewDataSource, DBRestClientDelegate {

    var fileArray: [AnyObject] = NSMutableArray() as [AnyObject]
    
    @IBAction func testbtn(sender: AnyObject) {
        print("123")
        for cell in TVUpload.visibleCells as! [UploadCell]{
            if(cell.selected == true){
                let filename = cell.lblFileName.text
                let localDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                let localPath = localDir.stringByAppendingPathComponent(filename!)
                //              Upload file to Dropbox
                let destDir: NSString = "/";
                print(localPath)
                self.restClient.uploadFile(filename, toPath: destDir as String, withParentRev: nil, fromPath: localPath)
            }
        }
    }
    var restClient = DBRestClient()
    
    @IBOutlet weak var TVUpload: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        restClient.delegate = self
        TVUpload.delegate = self
        TVUpload.dataSource = self
        let localDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localDir
        var directoryContent = NSArray()
        do{
            directoryContent = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(path as String)
        }
        for filename in directoryContent{
//            print(file)
            
            fileArray.append(filename)
        }
//        for file in fileArray{
//            print(file)
//        }
        
        self.TVUpload.registerClass(UploadCell.self, forCellReuseIdentifier: "Cell")
        self.TVUpload.registerNib(UINib(nibName: "UCell", bundle: nil), forCellReuseIdentifier: "MyCell2")
        // Do any additional setup after loading the view.
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell2", forIndexPath: indexPath) as! UploadCell
        let file = fileArray[indexPath.row]
        let name = file as! String
        cell.lblFileName.text = name
        let pos = name.characters.indexOf(".")
        let fileTypeName = name.substringFromIndex(pos!)
        print(fileTypeName)
        switch(fileTypeName){
        case ".exe": cell.imgFileType.image = UIImage(named: "exe.png")
        case ".png": cell.imgFileType.image = UIImage(named: "picture.png")
        case ".pdf": cell.imgFileType.image = UIImage(named: "pdf.png")
        case ".txt": cell.imgFileType.image = UIImage(named: "text.png")
        case ".doc": cell.imgFileType.image = UIImage(named: "doc.png")
        default: cell.imgFileType = UIImageView(image: UIImage(named: "unreadable.png"))
        }

        let localDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = localDir.stringByAppendingPathComponent(name)
        var attr: NSDictionary?
        do{
            attr = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
        }
        let size = attr!.fileSize()
        let fdate = attr!.fileModificationDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        let mydate = dateFormatter.stringFromDate(fdate!)
        cell.lblFileDate.text = String(mydate)
        cell.lblFileSize.text = String(size) + " Bytes"
        
        
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fileArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func ManualUpload(){
//        print("123")
//        for cell in TVUpload.visibleCells as! [UploadCell]{
//            if(cell.selected == true){
//                let filename = cell.lblFileName.text
//                let localDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//                let localPath = localDir.stringByAppendingPathComponent(filename!)
////              Upload file to Dropbox
//                let destDir: NSString = "/";
//                self.restClient.uploadFile(filename, toPath: destDir as String, withParentRev: nil, fromPath: localPath)
//            }
//        }
//    }
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        NSLog("File uploaded successfully to path %@", metadata.path)
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        NSLog("File upload failed with error: %@", error)

    }
    
}
