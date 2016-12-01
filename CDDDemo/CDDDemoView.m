//
//  CDDDemoView.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "CDDDemoView.h"
#import "CDDContext.h"
#import "MessageCellBase.h"
#import "ChatMessageBase.h"
#import "CDDDemoInputView.h"
#import "CDDDemoDataHandlerProtocol.h"
#import "CDDMutableArray.h"

#define kCDDDemoViewInputViewHeight     48
#define kKeyboardAnimationDuration      0.25f
#define kKeyboardAnimationCurve         7

@interface CDDDemoView () <UITableViewDataSource, UITableViewDelegate, CDDMutableArrayDelegate>
@property (nonatomic, strong) UITableView*                      tableView;
@property (nonatomic, strong) CDDDemoInputView*                 inputView;

@property (nonatomic, assign) BOOL                              isKeyboardVisible;
@property (nonatomic, assign) int                               kbHeight;
@end

@implementation CDDDemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)buildDemoView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.clipsToBounds = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self addSubview:self.tableView];
    
    CGRect inputFrame = self.bounds;
    inputFrame.size.height = kCDDDemoViewInputViewHeight;
    self.inputView = [[CDDDemoInputView alloc] initWithFrame:inputFrame];
    [self addSubview:self.inputView];
    [self.inputView initInputView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollingToBottom:false];
    });
    
    //observe datasource
    [[((id<CDDDemoDataHandlerProtocol>)self.context.dataHandler) getMessages] addArrayObserver:self];
    
    //observe keyboard events
    NSNotificationCenter* notif = [NSNotificationCenter defaultCenter];
    [notif removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notif addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutDemoView];
}

- (void)layoutDemoView
{
    int viewHeight = self.bounds.size.height;
    int viewWidth = self.bounds.size.width;
    int keyboardDisplayHeight = _isKeyboardVisible ? _kbHeight : 0;
    
    //layout inputView and return dynamic height
    float inputViewHeight = kCDDDemoViewInputViewHeight;
    
    CGRect inputHolderFrame = CGRectMake(0, viewHeight-keyboardDisplayHeight-inputViewHeight, viewWidth, inputViewHeight);
    if (!CGRectEqualToRect(inputHolderFrame, _inputView.frame)) {
        _inputView.frame = inputHolderFrame;
    }
    
    //layout main table
    BOOL inMiddleOfAnimation = [_inputView.layer.animationKeys count] > 0;
    float curHeight = viewHeight - (_inputView.hidden ? 0 : inputViewHeight);
    if (_isKeyboardVisible)
    {
        if (inMiddleOfAnimation) {
            float tableHeightChange = _tableView.frame.size.height - (curHeight-keyboardDisplayHeight);
            float yOffsetMove = tableHeightChange;
            if (_tableView.contentSize.height < _tableView.frame.size.height) { //content height too short, adjust yOffsetMove
                yOffsetMove -= (_tableView.frame.size.height-_tableView.contentSize.height);
                yOffsetMove = MAX(yOffsetMove, 0);
            }
            _tableView.frame = CGRectMake(0, -yOffsetMove, viewWidth, _tableView.frame.size.height);
        }
        else
        {
            [self fixMainTableFrame_AfterAnimation];
        }
    }
    else
    {
        _tableView.frame = CGRectMake(0, 0, viewWidth, curHeight);
    }
}

#define FixMainTableAction_AfterAnimation       0
#define FixMainTableAction_BeforeAnimation      1
- (void)fixMainTableFrame_BeforeAnimation
{
    [self adjustMainTableFrame:FixMainTableAction_BeforeAnimation];
}

- (void)fixMainTableFrame_AfterAnimation
{
    [self adjustMainTableFrame:FixMainTableAction_AfterAnimation];
}

- (void)adjustMainTableFrame:(int)action
{
    if (_inputView.layer.animationKeys.count > 0) {
        return;
    }
    int viewHeight = self.bounds.size.height;
    int viewWidth = self.bounds.size.width;
    int keyboardDisplayHeight = _isKeyboardVisible ? _kbHeight : 0;
    
    int inputHeight = _inputView.frame.size.height;
    float curHeight = viewHeight - inputHeight;
    
    if (action == FixMainTableAction_AfterAnimation)
    {
        _tableView.frame = CGRectMake(0,0,
                                      viewWidth,
                                      viewHeight - inputHeight - keyboardDisplayHeight);
        [self scrollingToBottom:false];
    }
    else if (action == FixMainTableAction_BeforeAnimation)
    {
        
        float yOffsetMove = _tableView.contentSize.height - (curHeight - _kbHeight);
        yOffsetMove = MIN(yOffsetMove, _kbHeight);
        yOffsetMove = MAX(yOffsetMove, 0);
        _tableView.frame = CGRectMake(0, -yOffsetMove, viewWidth, curHeight);
    }
}

- (void)scrollingToBottom:(BOOL)animated
{
    int cellCount = (int)[_tableView.dataSource tableView:_tableView numberOfRowsInSection:0];
    if (cellCount == 0) {
        return;
    }
    
    CGRect frame = _tableView.frame;
    CGFloat originY = 0;
    CGFloat contentHeight = _tableView.contentSize.height + originY;
    if (contentHeight > frame.size.height) {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:offset animated:animated];
    }
}


#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* msgs = [((id<CDDDemoDataHandlerProtocol>)tableView.context.dataHandler) getMessages];
    
    MessageCellBase* cell = NULL;
    
    ChatMessageBase* msg = [msgs objectAtIndex:indexPath.row];
    
    Class renderClass = [MessageCellBase getRenderClassByMessageType:msg.msgType.intValue];
    if (!renderClass) {
        return [UITableViewCell new];
    }
    NSString* cellIndentifier = NSStringFromClass(renderClass);
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[renderClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.chatMsg = msg;
    
    [cell doMessageRendering];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* msgs = [((id<CDDDemoDataHandlerProtocol>)tableView.context.dataHandler) getMessages];
    return msgs.count;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* msgs = [((id<CDDDemoDataHandlerProtocol>)tableView.context.dataHandler) getMessages];
    
    float cellHeight = 0;
    
    ChatMessageBase* msg = [msgs objectAtIndex:indexPath.row];
    cellHeight = msg.renderHeight;
    
    cellHeight = MAX(cellHeight, 0);
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
}

#pragma mark-   Data Source Events
- (void)didAddObject:(id)anObject withinArr:(CDDMutableArray*)arr
{
    if (arr == [((id<CDDDemoDataHandlerProtocol>)self.context.dataHandler) getMessages] && anObject) {
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollingToBottom:true];
        });
        
    }
}

- (void)didRemoveObject:(id)anObject withinArr:(CDDMutableArray*)arr
{
    if (arr == [((id<CDDDemoDataHandlerProtocol>)self.context.dataHandler) getMessages] && anObject) {
        [self.tableView reloadData];
        [self scrollingToBottom:true];
    }
}

#pragma mark-    Keyboard Events
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *keyBounds = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect bndKey;
    [keyBounds getValue:&bndKey];
    _kbHeight = bndKey.size.height;
    
    [self showTalkViewKeyboard];
}

- (void)showTalkViewKeyboard
{
    _isKeyboardVisible = true;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    double duration = kKeyboardAnimationDuration;
    int curve = kKeyboardAnimationCurve;
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    [self layoutDemoView];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fixMainTableFrame_AfterAnimation)];
    [UIView commitAnimations];
    
    [self scrollingToBottom:false];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
