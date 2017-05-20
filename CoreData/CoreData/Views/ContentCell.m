//
//  ContentCell.m
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import "ContentCell.h"
#import "Student.h"

@interface ContentCell ()

@property (nonatomic, strong) UILabel *labelStudentNo;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelGender;
@property (nonatomic, strong) UILabel *labelAge;

@end

@implementation ContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelStudentNo = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
        self.labelStudentNo.backgroundColor = [UIColor clearColor];
        self.labelStudentNo.textColor = [UIColor redColor];
        [self addSubview:self.labelStudentNo];
        
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(115, 5, 180, 30)];
        self.labelName.backgroundColor = [UIColor clearColor];
        self.labelName.textColor = [UIColor blackColor];
        [self addSubview:self.labelName];
        
        self.labelGender = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 30)];
        self.labelGender.backgroundColor = [UIColor clearColor];
        self.labelGender.textColor = [UIColor redColor];
        [self addSubview:self.labelGender];
        
        self.labelAge = [[UILabel alloc] initWithFrame:CGRectMake(115, 35, 180, 30)];
        self.labelAge.backgroundColor = [UIColor clearColor];
        self.labelAge.textColor = [UIColor blackColor];
        [self addSubview:self.labelAge];
    }
    return self;
}

- (void)showModel:(Student *)student
{
    if (student)
    {
        self.labelStudentNo.text = [NSString stringWithFormat:@"%@",student.studentNO];
        self.labelName.text = [NSString stringWithFormat:@"%@",student.name];
        self.labelGender.text = [NSString stringWithFormat:@"%@",student.gender];
        self.labelAge.text = [NSString stringWithFormat:@"%@",student.age];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
