

本框架使用注意事项：

1、lua文件命名，请尽量根据已有的命名格式进行增序添加。并通过函数modimport挂载去父节点（lua）里。通常在当前文件夹里都有一个父节点lua文件。具体可以参考查看 【Key_Modules_Of_FWD_IN_PDT\01_02_Ohter_Original_Prefabs_Upgrade\_All_Original_Prefabs_Upgrade_Init.lua】

2、prefab的东西已经用文件夹分类好了，每个文件夹里有个__prefabs_list.lua 的文件，根据示例格式添加。命名方式也使用数字开头。lua的命名并不会影响DST里的物品代码名，只是为了让MOD工程里显得整齐而已。

3、test_fn文件夹里是一些测试用的模块，其中的test.lua里有大量的MOD制作时候测试用的模块。使用最底部注释掉的dofile命令，在DST里控制台执行就能运行代码。使用的目的是不用频繁的reload游戏存档，加速MOD的开发工作。

已经做好的实用API和一些注意事项： 
1、 通用、常用函数模块化封装（fwd_in_pdt_func）： 具体前往 【\scripts\components\fwd_in_pdt_func.lua】 查看如何封装的。 不同的功能分到了不同的lua文件里面。 TheWorld 和 玩家inst实体 都有固定的加载初始化。不用担心重复初始化模块会造成问题，因为只有第一次初始化才有效，后面的将会跳过。
replica 的初始化参数使用了 net_string 进行 server2client 下发，通常来说延迟不会造成过多困扰。OnEntityWake 的时候 net_string 绑定的相关函数可能会重新激发执行（因为得到了服务器来的最新参数）。
TheWorld 的初始化在 【Key_Modules_Of_FWD_IN_PDT\01_01_TheWorld_Prefab_Upgrade\00_theworld_upgrade.lua】
玩家inst实体的初始化在 【Key_Modules_Of_FWD_IN_PDT\01_00_Player_Prefab_Upgrade\00_player_upgrade.lua】


2、 RPC_PushEvent ：解决大多数的server 和 client 的数据交互问题。 client 和 server的交互，如果需要即时响应，则使用 RPC_PushEvent 函数。
模块加载方法为 inst:AddComponent("fwd_in_pdt_func"):Init({"rpc"})。
server端使用 inst.components.fwd_in_pdt_func:RPC_PushEvent(event_name,data_table) 向client端下发，如果inst为非玩家实体，则会自动广播给当前世界的所有玩家。
client端使用 inst.replica.fwd_in_pdt_func:RPC_PushEvent(event_name,data_table) 向server端发送数据。
server 和 client 接收数据则使用官方的 inst:ListenForEvent 函数就行。 传送的数据使用的是json，里面不能用 function格式的内容。table里的内容上限没有测试过。
【注意】RPC_EVENT在一帧内多次使用可能会造成信道阻塞，如果非要这么做，建议使用 net_vars 系统， 无阻塞，但会延迟。
【提示】使用 RPC_PushEvent2 可以自动延迟顺序发送数据。如果启动了DEBUG模式，则会有对应的日志打印出来。client/server 都有
【scripts\components\fwd_in_pdt_func\02_RPC_Event.lua】
【Key_Modules_Of_FWD_IN_PDT\03_Auxiliary_File_Registration_System\01_RPC_register.lua】

3、 通用数据罐 fwd_in_pdt_data ：
加载方式： inst:AddComponent("fwd_in_pdt_data") ,只能在服务端使用。可以储存各种标记信息，不能储存 function。 
使用方式 inst.components.fwd_in_pdt_data:Get(name) , name 的格式为 string inst.components.fwd_in_pdt_data:Set(name,data) ，name 的格式为 string，data 可以是 任何非function的格式类型（通常是table/string/bool/number）。 
inst.components.fwd_in_pdt_data:Add(name,num) ,num必须给 number格式，是个简单的计数器。会有加减算法后的返回值。 这个储存空间的数据跟随存档保存。
制作这个模块的目的是避免数据挂载点混乱。
【注意】同时核心功能模块 fwd_in_pdt_data 也有一样的数据罐功能，注意储存读取的时候不要搞错。

4、 多语言支持： 语言文本格式可以参考 【\Imports_for_FWD_IN_PDT\02_00_Strings_Table_CH.lua】 上面这个格式封装是为了让同一个实体/事件的语言文本紧凑在一起。
部分字段是固定的，例如 name 、 inspect_str 、 recipe_desc 。【Imports_for_FWD_IN_PDT\04_DST_STRINGS_PRE_INIT.LUA】
这个格式封装和官方的封装并不冲突，其他MOD作者不喜欢的话，依旧可以使用和Klei官方一样的操作方法。

5、 玩家的 inst.AnimState 的转变： inst.AnimState 功能模块已经从 userdata 变为了 table。
具体请前往【\Key_Modules_Of_FWD_IN_PDT\04_AnimState_Hook_All_Original_AnimState_Upgrade_Init.lua 】
这么操作的目的是为了做出一些有趣的功能，方便其他MOD初学者进行相关API的HOOK。
该功能思路采用的是【棱镜】模组的hook逻辑，会和棱镜直接冲突。注意避让处理（通常为延时），或者使用MOD的加载优先级。


底层功能系统：
1、自定义密语系统，在聊天里添加只能指定玩家看见内容的文字。同时带图标自定义，以及图标带动画特效的功能
【Imports_for_FWD_IN_PDT\05_Chat_Message_Icons.lua】  这里添加和注册图标
【Key_Modules_Of_FWD_IN_PDT\06_widgets\02_Chat_Wisper_Event.lua】
【scripts\components\fwd_in_pdt_func\01_player_only_func.lua】里有执行API

2、自定义死亡/复活通告文字内容，可以某些事件造成玩家死亡/复活的时候【嘲笑】/【安慰】/【提示】玩家等，会发到公屏。 
【Key_Modules_Of_FWD_IN_PDT\00_Others\03_Death_Announce.lua】
【Key_Modules_Of_FWD_IN_PDT\00_Others\04_Resurrection_Announce.lua】
【scripts\components\fwd_in_pdt_func\01_player_only_func.lua】里有执行API

3、声音屏蔽系统，主要用来解决制作栏放技能产生的声音。
【Key_Modules_Of_FWD_IN_PDT\00_Others\02_Sound_hook.lua】
【scripts\components\fwd_in_pdt_func\01_player_only_func.lua】里有执行API

4、玩家出生的位置可自定义。
【Key_Modules_Of_FWD_IN_PDT\01_01_TheWorld_Prefab_Upgrade\01_theworld_player_spawner.lua】
【scripts\components\fwd_in_pdt_func\01_player_only_func.lua】里有执行API

5、岛屿/地形 创建系统，可以旧档插入该地形。
【scripts\components\fwd_in_pdt_func\09_theworld_map_modifier.lua】
【Key_Modules_Of_FWD_IN_PDT\07_island_house_creater\03_test_island_creater.lua】为岛屿创建示例。
【注意】创建的方案使用了Lua的协程功能，为的是避免岛屿创建的时候玩家和服务器连线断开。如果因此造成其他问题，需要解除该功能的协程。

6、皮肤替换系统，bank build 一起换的那种。涉及lua文件众多。可单个皮肤解锁。可批量皮肤解锁。同时附带镜像功能。
【Key_Modules_Of_FWD_IN_PDT\08_prefab_skin_sys】文件夹里
【scripts\components\fwd_in_pdt_func\00_01_skin_api_for_player.lua】玩家身上的执行组件。主要是皮肤所有权验证，以及扫把切换执行。
【scripts\components\fwd_in_pdt_func\00_02_skin_api_for_others.lua】非玩家目标上的执行组件，数据的加载和初始化。
【示例】【scripts\prefabs\07_fwd_in_pdt_buildings\00_example_mock_wall_grass.lua】示例文件。
自制皮肤切换工具组件，可以上一个/下一个来切换本MOD的皮肤物品。【Key_Modules_Of_FWD_IN_PDT\05_Actions\08_reskin_tool_action.lua】


7、资源生长组件。通常用于植物等。专门做了游戏防卡处理。
模式1：以秒为单位生长，利用了 LongUpdate 和 OnEntityWake/OnEntitySleep 进行交互处理。
模式2：在模式1的基础上封装了以天为单位的 API 。
【scripts\components\fwd_in_pdt_func\04_LongUpdate.lua】
【scripts\components\fwd_in_pdt_func\10_growable.lua】
【示例】【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\08_example_test_tree.lua】

8、任意资源刷新器，用于mod的矿石/植物/生物 刷新。
通常是资源inst被采集后放置该刷新器，避免mod资源枯竭。以天为单位。在玩家视野外才执行。OnEntityWake/OnEntitySleep
【scripts\prefabs\20_fwd_in_pdt_events\00_natural_resources_spawner.lua】

9、跨存档数据储存系统，用于A存档解锁了东西也能B存档使用，还可以去别人的存档使用。只在玩家身上添加。相关数据和userid绑定。
【scripts\components\fwd_in_pdt_func\01_04_cross_archived_data_sys.lua】

10、简易任意物品接受组件，可以一个组件就解决物品接受问题，包括独立的显示文本和SG动作动画。
【scripts\components\fwd_in_pdt_com_acceptable.lua】
【Key_Modules_Of_FWD_IN_PDT\05_Actions\04_item_acceptable_action__register.lua】
同时有辅助系组件，错误原因角色说出来的组件。
【scripts\components\fwd_in_pdt_com_action_fail_reason.lua】
【示例】【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\08_example_test_tree.lua】

11、简易任意inst交互组件（通常用于建筑等），可以一个组件就解决大多数的玩家和目标的交互问题，包括独立的显示文本和SG动作动画。
【scripts\components\fwd_in_pdt_com_workable.lua】
【Key_Modules_Of_FWD_IN_PDT\05_Actions\06_inst_workable_action__register.lua】
同时有辅助系组件，错误原因角色说出来的组件。
【scripts\components\fwd_in_pdt_com_action_fail_reason.lua】
【示例】【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\08_example_test_tree.lua】


12、鼠标放上去显示的文本颜色为自定义。server端下发参数。
【scripts\components\fwd_in_pdt_func\11_mouserover_str_colourful.lua】
【Key_Modules_Of_FWD_IN_PDT\06_widgets\03_mouseover_text_colourful.lua】

13、物品栏的图标上自定义覆盖特效FX。server端下发参数。
【scripts\components\fwd_in_pdt_func\12_item_tile_icon_fx.lua】
【Key_Modules_Of_FWD_IN_PDT\06_widgets\04_itemtile_icon_fx_anim.lua】


14、高阶任意物品接受组件，可以一个组件就解决物品接受问题，包括独立的显示文本和SG动作动画。
同时还可以服务器下发命令来切换 多组动作、test函数、文本。
简易组件的进阶版本。
靠服务器下发 index 切换
【scripts\components\fwd_in_pdt_com_special_acceptable.lua】
【Key_Modules_Of_FWD_IN_PDT\05_Actions\05_item_special_acceptable_action__register.lua】
同时有辅助系组件，错误原因角色说出来的组件。【scripts\components\fwd_in_pdt_com_action_fail_reason.lua】
【示例】【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\09_example_special_test_tree.lua】


15、高阶任意inst交互组件（通常用于建筑等），可以一个组件就解决大多数的玩家和目标的交互问题，包括独立的显示文本和SG动作动画。
同时还可以服务器下发命令来切换 多组动作、test函数、文本。
简易组件的进阶版本。
靠服务器下发 index 切换
【scripts\components\fwd_in_pdt_com_special_workable.lua】
【Key_Modules_Of_FWD_IN_PDT\05_Actions\07_inst_special_workable_action__register.lua】
同时有辅助系组件，错误原因角色说出来的组件。【scripts\components\fwd_in_pdt_com_action_fail_reason.lua】
【示例】【scripts\prefabs\__fwd_in_pdt_debugging_prefabs\09_example_special_test_tree.lua】

16、镜头数据服务器获取和下发设置。用于简单的服务端控制客户端的镜头操作。镜头旋转角度，镜头俯视角角度设置。（RPC）
【scripts\components\fwd_in_pdt_func\01_01_ThePlayerCamera.lua】

17、客制化物品拾取声音，可以新增任何物品的拾取声音。也可以特定角色给特定物品声音。注意index。
给物品添加 客制化拾取声音。使用函数 fwd_in_pdt_set_pick_sound(...)，在prefab 的生成函数里执行就行了。
【Key_Modules_Of_FWD_IN_PDT\00_Others\06_pick_sound_customization.lua】  
【scripts\components\fwd_in_pdt_func\01_02_pick_sound.lua】给指定角色指派特定声音，注意index。例如可以设置Woodie拾取木头有特定音效，其他角色没有。（RPC）

18、各类关键模块的 DoDelta 执行操作 ，可以很方便的在某些情况下在官方函数执行前得到数据响应拦截等操作（例如死亡的瞬间触发事件以避免死亡）。
官方虽然提供了执行完成后的相关event push，但是没有执行前的，某些极端情况下难以成功处理响应。
使用了这个，可以实现各种道具（非装备）拦截和处理相关的数据。例如体温恒定道具，潮湿度恒定道具,诅咒道具等。
饱食度，San,血量，体温，潮湿度。
【scripts\components\fwd_in_pdt_func\01_03_com_pre_dodleta.lua】

19、replca 初始化完成后可使用 event fwd_in_pdt_event.OnReplicated 执行对应的初始化，功能同官方提供的 inst.OnEntityReplicated 接口一样，但是方便更多。
【Key_Modules_Of_FWD_IN_PDT\00_Others\05_OnEntityReplicated_Event.lua】


20、玩家从制作栏制作物品的时候，同步播放特效inst_fx,时间轴控制得好的话，可以在特效播放完的瞬间，物品制作完成。
使用模块 fwd_in_pdt_com_builder_fx_for_recipe_making
参数添加示例：【Key_Modules_Of_FWD_IN_PDT\01_00_Player_Prefab_Upgrade\03_recipes_making_with_fx.lua】

21、日常任务/签到系统，真实的时间，每天只执行一次（利用了跨存档系统）
【scripts\components\fwd_in_pdt_func\01_06_daily_task.lua】

