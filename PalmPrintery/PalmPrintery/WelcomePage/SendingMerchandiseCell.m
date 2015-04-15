//
//  SendingMerchandiseCell.m
//  PalmPrintery
//
//  Created by zhiyong on 14/12/25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "SendingMerchandiseCell.h"
@interface SendingMerchandiseCell()
@property (weak, nonatomic) IBOutlet UILabel *cNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *iQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dDeliveryDateLabel;

@end

@implementation SendingMerchandiseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSendMerchandise:(PPSendMerchandise *)sendMerchandise{
    _sendMerchandise = sendMerchandise;
    if(_sendMerchandise){
        self.cNumberLabel.text = _sendMerchandise.cNumber;
        self.iQuantityLabel.text = [NSString stringWithFormat:@"%ld",_sendMerchandise.iQuantity];
        self.dDeliveryDateLabel.text = _sendMerchandise.dDeliveryDate;
    }
}

@end
