//
//  VCHome.swift
//  myBox
//
//  Created by VietHung on 8/10/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class VCHome: UIViewController, UITableViewDelegate, UITableViewDataSource, DBRestClientDelegate {
    
    @IBOutlet weak var recentTableV: UITableView!
    var fileArray: [AnyObject] = NSMutableArray() as [AnyObject]
//
//
    var restClient = DBRestClient()

    override func viewDidLoad() {
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        restClient = DBRestClient.init(session: DBSession.sharedSession())
        restClient.delegate = self
        recentTableV.delegate = self
        self.recentTableV.dataSource = self
        self.restClient.loadMetadata("/")
        super.viewDidLoad()
        self.recentTableV.registerClass(BasicCell.self, forCellReuseIdentifier: "Cell")
        self.recentTableV.registerNib(UINib(nibName: "BCell", bundle: nil), forCellReuseIdentifier: "MyCell")

//        testUpload()
    }
//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fileArray.count
    }
//
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        if(metadata.isDirectory){
            NSLog("Folder '%@' contains:", metadata.path);
            for file in metadata.contents{
                NSLog(String(file.filename));
                fileArray.append(file)
                print(fileArray.last?.filename)
            }
            self.recentTableV.reloadData()
        }
    }
//
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! BasicCell
        
        let file = fileArray[indexPath.row]
        let name = file.filename as String!
        let fsize = file.totalBytes
        cell.lblFileName.text = file.filename
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
        let fdate = file.lastModifiedDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        let mydate = dateFormatter.stringFromDate(fdate)
        cell.lblFileDate.text = mydate
        if(fsize > 1024 && fsize < 1024*1024){
            cell.labelFileSize.text = String(Float(fsize)/1024) + " KB"
        }
        else if(fsize > 1024*1024 && fsize < 1024*1024*1024){
            cell.labelFileSize.text = String(Float(fsize)/Float(1024^2)) + " MB"
        }
        else if(fsize > 1024*1024*1024 && fsize < 1024*1024*1024*1024){
            cell.labelFileSize.text = String(Float(fsize)/Float(1024^3)) + " GB"
        }
        else{
            cell.labelFileSize.text = String(fsize) + " Bytes"
        }
        return cell
    }
//    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func testUpload(){
//        let filemanager:NSFileManager = NSFileManager()
//        let files = filemanager.enumeratorAtPath(NSHomeDirectory())
//        while let file = files?.nextObject() {
//            print(file)
//        }
//        let text = "Hello world."
//        let filename = "working-draft.txt"
//        let localDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let localPath = localDir.stringByAppendingPathComponent(filename)
//        do {
//            _ =  try? text.writeToFile(localPath, atomically: true, encoding: NSUTF8StringEncoding)
//        }
//        listFilesAtPath(localDir)
////         Upload file to Dropbox
//        let destDir: NSString = "/";
//        self.restClient.uploadFile(filename, toPath: destDir as String, withParentRev: nil, fromPath: localPath)
//    }

    func listFilesAtPath(path: NSString){
        NSLog("LISTING ALL FILES FOUND")
        var directoryContent = NSArray()
        do{
            directoryContent = try! [NSFileManager.defaultManager().contentsOfDirectoryAtPath(path as String)]
        }
        
        for file in directoryContent{
            print(file)
        }
        
//        return directoryContent
    }
    
}
