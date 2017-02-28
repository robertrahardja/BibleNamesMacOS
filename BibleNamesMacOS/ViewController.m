//
//  ViewController.m
//  BibleNamesMacOS
//
//  Created by Robert Rahardja on 24/2/17.
//  Copyright © 2017 Robert Rahardja. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UITextField *InputText;
@property (weak) IBOutlet NSTextField *InputText;

//@property (weak, nonatomic) IBOutlet UITextView *OutputText;
@property (unsafe_unretained) IBOutlet NSTextView *OutputText;




@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSMutableString *string;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Download github plist
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlToDownload = @"https://raw.githubusercontent.com/robertrahardja/BibleNamesDictionary/master/BibleNamesPlist.plist";
        NSURL  *url = [NSURL URLWithString:urlToDownload];
      //Populate dict with github plist
        if ( url )
        {
            
            
            self.dict = [NSDictionary dictionaryWithContentsOfURL:url];
           
        }
        
    });

}
- (IBAction)TranslateButton:(id)sender {


    self.string = [NSMutableString stringWithString: self.InputText.stringValue];
    for (NSString *key in self.dict) {
        
        NSString *def = [self.dict valueForKey:key];
        NSString *pattern = [NSString stringWithFormat: @"\\b%@\\b", key];
        NSString *defpattern = [NSString stringWithFormat:@"\n $0: (%@)\n", def];
        
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSString *newString =
        [regex stringByReplacingMatchesInString:self.string options:0 range:NSMakeRange(0, [self.string length])  withTemplate:defpattern]
        ;
        
        self.string = [NSMutableString stringWithString: newString];
        
        self.OutputText.string = self.string;
        
        //NSLog(@"key:%@\ndef:%@", key, def);
        
    };
    //[self.InputText resignFirstResponder];

    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
