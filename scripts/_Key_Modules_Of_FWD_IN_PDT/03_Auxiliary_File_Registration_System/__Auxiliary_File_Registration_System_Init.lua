-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径

-- 本类别注册各种组件，包括 replica ，制造栏的栏目/物品添加，RPC系统等

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/03_Auxiliary_File_Registration_System/00_replica_register.lua")    
--- 注册 com 及其replica 组件


modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/03_Auxiliary_File_Registration_System/01_RPC_register.lua")    
--- 注册RPC系统 