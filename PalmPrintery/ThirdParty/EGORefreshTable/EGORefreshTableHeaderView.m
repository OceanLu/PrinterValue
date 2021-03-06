//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define kPullDownToRefresh      @"下拉开始刷新"
#define kReleaseToRefresh       @"松开即可开始刷新"
#define kLoading                @"正在加载..."
#define kLastUpdatedFormat      @"最后更新：%@"

#define kUpdatingHeight        40.0f


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor blackColor];

		UILabel *label;// = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont systemFontOfSize:11.0f];
//		label.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
////		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
////		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = NSTextAlignmentCenter;
//		[self addSubview:label];
//		_lastUpdatedLabel=label;
//		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 28.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:11.0f];
		label.textColor = [UIColor whiteColor];
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
//		[label release];
		
		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(25.0f, frame.size.height - kPullDownOffset, 30.0f, 55.0f);
		layer.frame = CGRectMake(85.0f, frame.size.height - 28.0f, 20.0f, 20.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refresh_indicator"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
//		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(85.0f, frame.size.height - 28.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
//		[view release];
		
		
		[self setState:EGOOPullRefreshNormal];
	}
	
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)])
    {
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
        if (date)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd HH:mm"];
            _lastUpdatedLabel.text = [NSString stringWithFormat:kLastUpdatedFormat, [formatter stringFromDate:date]];
        }
        else
        {
            _lastUpdatedLabel.text = [NSString stringWithFormat:kLastUpdatedFormat, @"从未"];
        }
		
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
//		[formatter release];
	}
    else
    {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState
{
	switch (aState)
    {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = kReleaseToRefresh;
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = kPullDownToRefresh;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = kLoading;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == EGOOPullRefreshLoading)
    {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, kUpdatingHeight + _edgeInset.top);
	    scrollView.contentInset = UIEdgeInsetsMake(offset, _edgeInset.left, _edgeInset.bottom, _edgeInset.right);
	}
    else if (scrollView.isDragging)
    {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
        {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -kPullDownOffset-_edgeInset.top && scrollView.contentOffset.y < 0.0f && !_loading)
        {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -kPullDownOffset-_edgeInset.top && !_loading)
        {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != _edgeInset.top)
        {
            scrollView.contentInset = _edgeInset;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= -kPullDownOffset-_edgeInset.top && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
        {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(_edgeInset.top + kUpdatingHeight, _edgeInset.left, _edgeInset.bottom, _edgeInset.right);
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    scrollView.contentInset = _edgeInset;
    [UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}

- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView
{
    [self setState:EGOOPullRefreshLoading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(_edgeInset.top + kUpdatingHeight, _edgeInset.left, _edgeInset.bottom, _edgeInset.right);
    [UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
    {
        [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
//    [super dealloc];
}


@end
