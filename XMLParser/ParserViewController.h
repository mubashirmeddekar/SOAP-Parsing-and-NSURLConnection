//
//  ParserViewController.h
//  XMLParser
//
//  Created by Mubashir Meddekar on 12/09/2014.
//  Copyright (c) 2014 Mubashir Meddekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParserViewController : UIViewController<NSXMLParserDelegate>
{
    NSURLConnection *conn;
    NSMutableData *webData;
    NSString *matchingElement;
    
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL elementFound;
}
@property (strong, nonatomic) IBOutlet UITextField *myText;
- (IBAction)buttonPressed:(id)sender;

@end
