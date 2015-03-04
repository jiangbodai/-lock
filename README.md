# 手势解锁 首先你需要导入RHTouchLockView.h，然后在你的代码中.实例化一个lockView。(2ez4u)

(void)viewDidLoad { [super viewDidLoad];

_lockView = [[RHTouchLockView alloc] initWithFrame:self.view.bounds]; [_lockView setBackgroundColor:[UIColor redColor]]; _lockView.Delegate = self; _lockView.opaque = YES; _lockView.time = 3.0f; _lockView.lineWidth = 10.0f; [self.view addSubview:_lockView]; }
