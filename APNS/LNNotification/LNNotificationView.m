//
//  LNNotificationView.m
//  LNNotificationsUI
//
//  Created by Leo Natan on 9/5/14.
//  Copyright (c) 2014 Leo Natan. All rights reserved.
//

#import "LNNotificationView.h"
#import "LNNotification.h"

static const CGFloat LNNotificationRelativeLabelCollapse = 5.0 * 60.0;

@implementation LNNotificationView
{
	UIImageView* _appIcon;
	UILabel* _titleLabel;
	UILabel* _dateLabel;
	UILabel* _messageLabel;
	
	UIView* _notificationContentView;
	UIVisualEffectView* _backgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if(self)
	{
		self.userInteractionEnabled = NO;
		
		self.backgroundColor = [UIColor clearColor];
		
		UIVisualEffectView* bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
		bgView.frame = self.bounds;
		bgView.userInteractionEnabled = NO;
		bgView.translatesAutoresizingMaskIntoConstraints = NO;
		bgView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		UIView* contV = bgView.contentView;
		
		[bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];
		[bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];
		
		[self addSubview:bgView];
		
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgView)]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgView)]];
		
		_notificationContentView = [[UIView alloc] initWithFrame:self.bounds];
		_notificationContentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		_appIcon = [UIImageView new];
		_appIcon.contentMode = UIViewContentModeScaleAspectFit;
		_appIcon.translatesAutoresizingMaskIntoConstraints = NO;
		
		[_appIcon addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_appIcon(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_appIcon)]];
		[_appIcon addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_appIcon(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_appIcon)]];
		
		[_notificationContentView addSubview:_appIcon];
		
		[_notificationContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7.5-[_appIcon]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_appIcon)]];
		
		_titleLabel = [UILabel new];
		_titleLabel.font = [UIFont boldSystemFontOfSize:13];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		
		[_notificationContentView addSubview:_titleLabel];
		
		_messageLabel = [UILabel new];
		_messageLabel.font = [UIFont systemFontOfSize:13];
		_messageLabel.textColor = [UIColor whiteColor];
		_messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_messageLabel.numberOfLines = 2;
		
		[_notificationContentView addSubview:_messageLabel];
		
		[_notificationContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7.5@1000-[_titleLabel]-(-1)-[_messageLabel]->=10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _messageLabel)]];
		[_notificationContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_appIcon]-11-[_messageLabel]->=15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_appIcon, _messageLabel)]];
		
		_dateLabel = [UILabel new];
		_dateLabel.font = [UIFont systemFontOfSize:11];
		_dateLabel.textColor = [UIColor whiteColor];
		_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[_dateLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[_dateLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
		[_dateLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[_dateLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
		
		UIVisualEffectView* dateBG = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(id)bgView.effect]];
		dateBG.translatesAutoresizingMaskIntoConstraints = NO;
		dateBG.contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		[dateBG.contentView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[dateBG.contentView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
		[dateBG.contentView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[dateBG.contentView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
		
		[dateBG setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[dateBG setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
		[dateBG setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
		[dateBG setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
		
		[dateBG.contentView addSubview:_dateLabel];
		[dateBG.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dateLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel)]];
		[dateBG.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dateLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel)]];
		
		contV = dateBG.contentView;
		
		[dateBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];
		[dateBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];
		
		[_notificationContentView addSubview:dateBG];
		
		[_notificationContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_titleLabel]-9.5-[dateBG]" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(_appIcon, dateBG, _titleLabel)]];
		[_notificationContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_appIcon]-11-[_titleLabel]-9.5-[dateBG]->=15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_appIcon, dateBG, _titleLabel)]];
		
		[bgView.contentView addSubview:_notificationContentView];
		
		[bgView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_notificationContentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_notificationContentView)]];
		[bgView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_notificationContentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_notificationContentView)]];
		
		UIView* drawer = [UIView new];
		drawer.backgroundColor = [UIColor whiteColor];
		drawer.translatesAutoresizingMaskIntoConstraints = NO;
		
		UIVisualEffectView* drawerBG = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(id)bgView.effect]];
		drawerBG.translatesAutoresizingMaskIntoConstraints = NO;
		drawerBG.contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		[drawerBG.contentView addSubview:drawer];
		[drawerBG.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[drawer(37)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(drawer)]];
		[drawerBG.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[drawer(5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(drawer)]];
		
		contV = drawerBG.contentView;

		[drawerBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];
		[drawerBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contV)]];

		[bgView.contentView addSubview:drawerBG];
		
		[bgView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[drawerBG]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(drawerBG)]];
		[bgView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:drawerBG
																	   attribute:NSLayoutAttributeCenterX
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:bgView.contentView
																	   attribute:NSLayoutAttributeCenterX
																	  multiplier:1.f constant:0.f]];
		
		UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 37, 5) cornerRadius:3];
		CAShapeLayer* layer = [CAShapeLayer layer];
		layer.path = path.CGPath;
		
		drawer.layer.mask = layer;
		
		_backgroundView = bgView;
	}
	
	return self;
}

- (UIVisualEffectView *)backgroundView
{
	return _backgroundView;
}

- (UIView *)notificationContentView
{
	return _notificationContentView;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	_messageLabel.preferredMaxLayoutWidth = self.bounds.size.width - (15 + _appIcon.frame.size.width + 8 + 15);
}

- (void)configureForNotification:(LNNotification*)notification
{
	_currentNotification = notification;
	
	if(notification == nil)
	{
		return;
	}
	
	_appIcon.image = notification.icon;
	_titleLabel.text = notification.title;
	_messageLabel.text = notification.message;
	
	if(notification.displaysWithRelativeDateFormatting && fabs([notification.date timeIntervalSinceNow]) <= LNNotificationRelativeLabelCollapse)
	{
		_dateLabel.text = NSLocalizedString(@"now", @"");
	}
	else
	{
		NSCalendar* calendar = [NSCalendar currentCalendar];
		
		unsigned unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
		NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
		NSDateComponents* comp2 = [calendar components:unitFlags fromDate:notification.date];
		
		NSDateFormatter* formatter = [NSDateFormatter new];
		
		if([[calendar dateFromComponents:comp1] compare:[calendar dateFromComponents:comp2]] == NSOrderedSame)
		{
			[formatter setTimeStyle:NSDateFormatterShortStyle];
			[formatter setDateStyle:NSDateFormatterNoStyle];
		}
		else
		{
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			[formatter setDateStyle:NSDateFormatterShortStyle];
		}
		
		formatter.doesRelativeDateFormatting = notification.displaysWithRelativeDateFormatting;
		
		_dateLabel.text = [[formatter stringFromDate:notification.date] lowercaseString];
	}
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
