## Usage
`#import "UIView+HBReveal.h"`

```objc
UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:@"SidebarView"
                                                     owner:self options:nil] lastObject];

// show the sidebar
[self.view reveal:contentView slide:kSlideRight hideCallback:nil];

// hide the sidebar
[self.view conceal:YES/*animated*/];

...

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // if a new controller is pushed, this controller will reset to the original
    // view and remove the sidebar, so reshow if it wasn't closed
    [self.view revealIfNeeded];
}
```

Demo:  
[![HBReveal Demo][t9ENROH_mis_img]][t9ENROH_mis_link]
[t9ENROH_mis_link]: http://www.youtube.com/watch?v=t9ENROH_mis "HBReveal Demo"
[t9ENROH_mis_img]: http://img.youtube.com/vi/t9ENROH_mis/3.jpg "HBReveal Demo"

Included Demo App:  
[![Included Demo App][uQCZCQoJ_X4_img]][uQCZCQoJ_X4_link]
[uQCZCQoJ_X4_link]: http://www.youtube.com/watch?v=uQCZCQoJ_X4 "Included Demo App"
[uQCZCQoJ_X4_img]: http://img.youtube.com/vi/uQCZCQoJ_X4/2.jpg "Included Demo App"
