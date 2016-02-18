# CDD

从2010年开始接触iOS开发到现在，折腾过不少app的架构。从[MVC](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)到[MVVM](https://www.objc.io/issues/13-architecture/mvvm/)，[VIPER](https://www.objc.io/issues/13-architecture/viper/)，[MVP](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)，以及最新的[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)都做过实战尝试，还有其他变种，诸如[猿题库iOS客户端架构设计](http://mp.weixin.qq.com/s?__biz=MjM5NTIyNTUyMQ==&mid=444322139&idx=1&sn=c7bef4d439f46ee539aa76d612023d43&scene=0#wechat_redirect)，也做过一些学习研究。这些技术概念如果不熟悉，建议每个链接都点开好好研读下，不要对你的大脑太温柔。在开始架构讨论之前，再推荐一些其他非常值得一读的文章：[唐巧－被误解的 MVC 和被神化的 MVVM](http://mp.weixin.qq.com/s?__biz=MjM5NTIyNTUyMQ==&mid=407454565&idx=1&sn=f2c207e30f700219d5811371b34b8cf9&scene=21#wechat_redirect)， [Casa Taloyum iOS架构系列文章](http://casatwy.com/iosying-yong-jia-gou-tan-kai-pian.html)，[objc.io架构系列文章](https://www.objc.io/issues/13-architecture/)。

## **1.应用层架构定义**

其实严格来说，MVC和其他类似概念还算不上一个完整的架构。一个颇具规模的app必然会涉及到分层的设计，还有模块化，hybrid机制，热补丁等等。MVC这种更像是个设计模式，解决的只是app分层设计当中的应用层（Applicaiton Layer）组织方式。对于一些简单app来说，可能应用层一层就完成了整个app的架构，不用担心业务膨胀对后期开发的压力。这里我介绍一种新的应用层架构方式，名之为CDD：Context Driven Design。

先明确下我们讨论的范畴，什么是一个app的应用层呢？现在不少app都会做一个分层的设计，一般为三层：应用层，service层，data access层。每一层再通过面向接口的方式产生依赖。

* 应用层是直接和用户打交道的部分，也就是我们常常用到的UIViewController，负责数据的展示，用户交互的处理，数据的采集等等。
* service层位于应用层的下面，为应用层提供公共的服务接口，对应用层来说就像是一个server，不过api调用的延迟为0ms，service层里放哪些代码做法没有统一的规范，一般来说会包含业务数据的处理，网络接口的调用，公共系统服务api封装（比如gps定位，相册，权限控制）等等。
* data access层顾名思义是负责处理我们app的基础数据，api设计规范一般遵循[CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)。这一层位于service层的下方，提供数据库交互所需的api。

这是基础部分，不同的团队具体做法又会有一些差异。比如有些把data access层又叫做model层，有些把网络模块放在service层，有些则放在data acess层，有些把部分的业务数据放到model里面做成胖model，有些则坚持使用瘦model，把业务代码放在独立的地方统一管理，等等差异不一而足。除了分层还有一些公共模块的设计，比如数据库，网络，安全，热补丁，hybrid机制，性能监测模块，日志模块等等如何配合分层设计，这里就不一一展开了。我们今天讨论的重点在应用层。

首先严正声明，这个CDD其实是我很久之前看Android代码脑洞出来的>_<||| ，刚好解决了我之前组织应用层代码的一个痛点。做过Android的朋友应该都知道，在很多类里都可以通过getContext方法获取到一个context，再通过这个context可以获取到其他系统资源。当时我第一次了解完这个context概念的时候，瞬间产生了一个这样的脑洞：

<img src="http://mrpeak.cn/images/cdd_initial.png" width="594">

我知道这灵光一闪的脑洞有点大，容我慢慢道来。前面提到应用层其实是在管理一堆UIViewController。拿微信做例子（我真的很喜欢拿微信举个栗子），首页4个tab，4个界面，4个controller，每个controller都有很多UI元素，点击又可以进入二级的controller，各controller可以看成一个独立的模块，有些简单，有些复杂。比如聊天界面这个controller就非常非常的复杂。先来看下聊天界面。

<img src="http://mrpeak.cn/images/cdd_wechat.jpg" width="320">


这个界面展示的UI元素非常之多，顶部导航栏，消息tableView，输入框部分，功能入口部分，可点击交互的部分也很多。如果我们把所有这些UI元素和交互的处理都放倒Controller里面，我们将得到一个著名的MVC（Massive View Controller），我曾经就有幸维护过一个这样controller，一个类文件一万多行代码，修起bug来十分的酸爽。很显然，我们的目标是拆分代码，所谓的架构不就是“以低耦合的方式分散业务复杂度”嘛。如果我们能把这些UI元素放倒不同的xxxView.m里面，交互的处理也有单独的类，目标达成。但新的问题是这些分散的各个类文件之间怎么交互，怎么耦合，怎么合体。MVC，MVVM，MVP等等都是在解决这个问题。这里我们团结各个类文件的方式是Context！建议再回看下上面的脑洞图。

在近一步深入讨论CDD之前，我们再重点强调下一个概念，data flow（还有其他别名，info flow，数据流等）。data flow是架构优劣的测量标准，好的架构一定有清晰的data flow，你说你架构怎么好，但data flow说不清楚，No，No，我们不约。什么是data flow，就是数据在你的app里流动的路线，就像人体血管里的血液，滋养着各个器官的运作。上面的聊天界面里，用户在输入框输入一个“hello”文本，文本被你包装成message model，再保存到db，再发送到服务器，最后在界面上展示给用户，这就是一个完整的data flow。实际的data经历的模块会更多，大部分的bug都是data除了问题，修bug时就是在顺着这个flow顺藤摸瓜，把脉诊断。

再问个问题，什么是data？你可以说data是model，是上面的“hello”文本。但我们还可以站在更高的角度来看待data，data是程序世界的基本元素，另一个基本元素是verb（动作），程序的世界里的所有存在都可以由这两个元素来描述，此处应该双手合十，进入冥想三分钟。推荐一篇[大神吐槽java的文章](http://steve-yegge.blogspot.com/2006/03/execution-in-kingdom-of-nouns.html)。

## **2.CDD架构详解**

接下来进入正题，剖析CDD。我们先把应用层分解成三块任务：

* UI的展示，UI的展示通过分解UIView可以实现复杂度的分散，UI的变化则可以参考MVVM的方式，通过观察者模式（KVO）来实现。
* 业务的处理，业务处理为了方便管理不能分散到不同的类，反而需要放到统一的地方管理，业务代码太分散会给调试带来很大的麻烦。
* data flow，所有数据的变化可以在统一的地方被追踪。数据的流向单一清晰。

在这三块划分的前提下我们再来制定CDD要达成的目标：

* view的展示可以被分解成若干个子view.m文件，各自管理。
* 业务处理代码放到统一的BusinessObject.m文件来管理。
* model的变化有统一的类DataHandler.m文件来管理。
* UIViewController里面只存放Controller生命周期相关的代码，做成轻量级的Controller。
* 所有子view可以处理只和自己相关的逻辑，如果属于整体的业务逻辑，则需要通过context传输到BusinessObject来处理。
* 子view展示所需的数据可以通过context获取到，并通过KVO的方式直接进行绑定。

根据这些目标，我把脑洞图完善下就得到了下面一个更清晰的方案图：

<img src="http://mrpeak.cn/images/cdd_update.png" width="804">

到这里context的作用就很明显了，context可以把所有的子view都连接起来，可以把业务逻辑都导向同一个地方，可以把数据的管理都集中在一个类。所有的类都可以访问到context，但各部分只通过接口产生依赖，将耦合降至最低。至此CDD的大致结构就完成了，但还有一个问题需要解决。view的更新需要跟数据直接绑定，需要做成数据驱动的模式，类似MVVM。

**但是我们怎么定义数据的变化呢？**

做数据驱动的设计就一定要有一套规范去定义数据的变化，在应用层数据的变化我们可以主要分为两类。一是model本身property的变化，这种变化可以用KVO来监听，很方便。另一种是集合类的变化，比如array，set，dictionary等，这类变化又包括元素的增删替换，Objective-C没有提供原生的支持来监听这类变化，所以我们需要自己定一个子类，再通过重载增删替换方法来实现，在Demo中我就定义了一个CDDMutableArray。定义数据的变化十分关键，直接关系到我们怎么去设计data flow。data access层也需要定义一套规范，这里就不展开了。

**CDD的data flow是怎样的呢？**

前面提到了data flow是架构是否清晰的评判标准，是我们debug时的主要依赖。基于上面的讨论CDD的data flow是这样的：

<img src="http://mrpeak.cn/images/cdd_flow.png" width="773">

我之前提到说CDD解决了我之前的一个痛点，其实就是分散复杂度时，需要大量的delegate传递来连接各个类，很多地方都需要引用protocol，比如输入框view产生的“hello”文本要通过delegate传递给superview，superview可能还有superview，再到controller，controller再传递给业务处理的类，最后可能还要通过delegate做回传。但我们看下CDD的整个flow，Controller就像是一个旁观者，根本不需要参与到任何数据的传递，仅仅作为各个对象的持有者，只处理controller本身相关的业务，比如view appear，disappear，rotate等，controller也是context的持有者，也可以在viewWillAppear的时候把事件传递到BusinessObject进行处理。

输入框view产生的“hello”文本，直接通过context传递到BusinessObject进行处理，生成的新消息message通过DataHandler插入到message array之后，直接通知到message tableview进行刷新。方法调用的路径变短了，意味着调试的时候step over的次数减少了。

这里有一点需要讨论下，view和context之间耦合的方式。view产生的数据要交给BusinessObject进行处理，那么这二者之间必然要产生耦合。耦合的方式有很多种：

* 只通过model进行耦合，二者只需要引用相同的model就可以进行交互，MVVM里view通过KVO的方式监听model变化就是这种耦合，这种耦合最弱，但调试会麻烦一些。
* 通过model+protocol进行耦合。耦合的双方需要引用相同的model和protocol文件。这种方式属于面向接口编程的范畴，耦合也比较弱，但比上面的方式强。优点是调试方便，delegate的调试可以单步step into。
* 通过model＋class进行耦合。这是我们最不愿意看到的耦合方式，类与类之间直接相互引用，任何一方变化都有可能引起潜在的bug。

view与context之间耦合的方式采用的是第二种，方便调试且耦合清晰。view会引用business object和data handler实现的相关协议，进而调用。

## **3.CDD架构Demo实战**

No Code，No BB。接下来我们用这套CDD的方案来实现一个类似微信的聊天界面。附上github DEMO地址，与朋友们一起学习研究。

我们会通过demo实现这样一个Controller：

<img src="http://mrpeak.cn/images/cdd_chat.jpg" width="320">

这个demo主要实现两个功能来帮助大家了解CDD的workflow。一个是上面提到过的发送消息流程，二是点击头像之后可以进入用户详情的Controller，详情Controller里面可以改变用户的名字，改变之后聊天界面的MrPeak的名字也会以数据驱动的方式自动更新。

**Demo实现细节：**

CDD实现并不复杂，关键类如下：

<img src="http://mrpeak.cn/images/cdd_structure.png" width="265">

CDDContext就是之前提到的核心类context，还包含CDDDataHandler， CDDBusinessObject基类的定义。

NSObject+CDD给每个NSObject对象添加一个CDDContext指针。

UIView+CDD则通过swizzling的方式给每个UIView自动添加CDD。

CDDMutableArray实现对Array的观察者模型。

针对某个Controller实现规范如下：

<img src="http://mrpeak.cn/images/cdd_demo.png" width="292">

CDDContext，CDDDataHandler，CDDBusinessObject均在Controller当中生成。protocol定义接口部分的耦合。ViewModel是应用层当中的model，和View的展示通过KVO直接绑定。View部分则是我们拆分过后的子view。


## **4.CDD架构后续工作**

CDD还处于初级阶段，是很久之前脑洞的产物，最近空一点才找机会把他变成代码。后面我会尝试在成熟的项目里去进一步完善并应证其合理性，也欢迎朋友们一起研究讨论。

后期可能进行的工作有：

* 完善对更多集合类的支持，比如Dictionary, Set等。
* BusinessObject在业务庞大的时候还是有可能膨胀，变得难以维护，可以尝试做进一步分解。
* 现在Context的赋值是通过didAddSubview去hack实现的，应该还有更多的场景需要去完善。
* 现在每个UIView包括系统（比如导航栏）控件都会去赋值Context，可能需要一种机制只对定制的UIView进行赋值。
* 给Demo添加更多的功能场景。
* 待补充。。。


