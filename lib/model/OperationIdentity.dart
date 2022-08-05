//保存开始时为Saver，结束后立刻变为None
//开始共享时为Sharer,结束后立刻变为None
//开始观看时为Watcher,结束后立刻变为None
//除了Watcher,其他的状态画板的屏幕都需要录制
//身份变量暂时由屏幕分享Provider进行管理
enum OperationIdentity { Saver, Sharer, Watcher, None }
