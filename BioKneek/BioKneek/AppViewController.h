/*
 Copyright (c) 2013 OpenSourceRF.com.  All right reserved.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <UIKit/UIKit.h>
#import "FeedbackViewController.h"
#import "SettingsViewController.h"

#import "RFduino.h"

@interface AppViewController : UIViewController<RFduinoDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) RFduino *rfduino;
@property (nonatomic, strong) UILabel *FSR1Value;
@property (nonatomic, strong) UILabel *FSR2Value;
@property (nonatomic, strong) UILabel *FSR3Value;
@property (nonatomic, strong) UILabel *FSR4Value;
@property (nonatomic, strong) UILabel *FSR5Value;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) FeedbackViewController* feedbackVC;
@property (nonatomic, strong) SettingsViewController* settingsVC;

@property (nonatomic, strong) UIView *grid;
@property (nonatomic, strong) CellView *cell1;
@property (nonatomic, strong) CellView *cell2;
@property (nonatomic, strong) CellView *cell3;
@property (nonatomic, strong) CellView *cell4;

//FUNCTIONAL
@property (nonatomic, strong) NSMutableArray* traininigData;
@property (nonatomic) int unbalanceCounter;

- (void) calibrateButtonClick: (id) sender;
- (void) calibrateButtonRelease: (id) sender;

//BLE
@property (nonatomic, strong) UIView *btConnectionIndicator;

- (void) btConnectionChanged: (BOOL) state;

@end
