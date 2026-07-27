'###############################################################################
'#  WStringList_Ex.bas                                                         #
'#  WStringList 全面测试程序                                                    #
'###############################################################################
#include once "mff/WStringList.bi"

' 测试计数器
Dim Shared As Integer g_Passed = 0, g_Failed = 0, g_TestNum = 0

Sub StartTest(ByRef s As WString)
	g_TestNum += 1
	Print "-------- 测试(Testing) " &  g_TestNum &  ": " &  s & " --------"
End Sub

Sub Pass()
	g_Passed += 1
	Print "  √ 通过(Success)"
End Sub

Sub Fail(ByRef s As WString)
	g_Failed += 1
	Print "  × 失败(Failed ): " & s
End Sub

Sub AssertEq(ByRef s As WString, actual As Integer, expected As Integer)
	If actual = expected Then Pass() Else Print "  × 失败(Failed ): " &  s &  " 期望" &  expected &  " 实际" &  actual : g_Failed += 1
End Sub

Sub AssertWs(ByRef s As WString, ByRef actual As Const WString, ByRef expected As Const WString)
	If actual = expected Then Pass() Else Print "  × 失败(Failed ): " &  s &  " 不匹配" : g_Failed += 1
End Sub

Sub AssertOk(ByRef s As WString, cond As Boolean)
	If cond Then Pass() Else Print "  × 失败(Failed ): " &  s &  " 期望True" : g_Failed += 1
End Sub

Sub AssertNot(ByRef s As WString, cond As Boolean)
	If Not cond Then Pass() Else Print "  × 失败(Failed ): " &  s &  " 期望False" : g_Failed += 1
End Sub

' ========================= 事件测试辅助 =========================
Dim Shared As Integer g_OnAdd_Calls = 0
Dim Shared As Integer g_OnInsert_Calls = 0
Dim Shared As Integer g_OnRemove_Calls = 0
Dim Shared As Integer g_OnExchange_Calls = 0
Dim Shared As Integer g_OnClear_Calls = 0
Dim Shared As Integer g_OnChange_Calls = 0

Sub ResetEvt()
	g_OnAdd_Calls = 0
	g_OnInsert_Calls = 0
	g_OnRemove_Calls = 0
	g_OnExchange_Calls = 0
	g_OnClear_Calls = 0
	g_OnChange_Calls = 0
End Sub

Sub OnAdd_CB(ByRef Sender As WStringList, iValue As Const WString, Obj As Any Ptr = 0)
	g_OnAdd_Calls += 1
End Sub
Sub OnInsert_CB(ByRef Sender As WStringList, Index As Integer, ByRef iValue As Const WString, Obj As Any Ptr = 0)
	g_OnInsert_Calls += 1
End Sub
Sub OnRemove_CB(ByRef Sender As WStringList, Index As Integer)
	g_OnRemove_Calls += 1
End Sub
Sub OnExchange_CB(ByRef Sender As WStringList, Index1 As Integer, Index2 As Integer)
	g_OnExchange_Calls += 1
End Sub
Sub OnClear_CB(ByRef Sender As WStringList)
	g_OnClear_Calls += 1
End Sub
Sub OnChange_CB(ByRef Sender As WStringList)
	g_OnChange_Calls += 1
End Sub

' ========================= 主测试 =========================
Print "================================================"
Print "  WStringList 全面测试程序"
Print "================================================"
Print

'----- 1. 基本操作 Add/Count/Item/[] -----
StartTest("基本操作: Add/Count/Item/[]")
Dim As WStringList sl1
sl1.Add("apple")
sl1.Add("banana")
sl1.Add("cherry")
AssertEq("Count=3", sl1.Count, 3)
AssertWs("Item(0)", sl1.Item(0), "apple")
AssertWs("Item(2)", sl1.Item(2), "cherry")
AssertWs("操作符[1]", sl1[1], "banana")

StartTest("Add空字符串")
sl1.Add("")
AssertEq("允许空字符串", sl1.Count, 4)

StartTest("Add返回值")
Dim As WStringList sl1b
AssertEq("Add#0", sl1b.Add("first"), 0)
AssertEq("Add#1", sl1b.Add("second"), 1)

StartTest("ItemSetter")
sl1b.Item(0) = "modified"
AssertWs("修改后", sl1b[0], "modified")

StartTest("CountSetter不影响")
sl1b.Count = 100
AssertEq("Count不变", sl1b.Count, 2)

'----- 2. Sort -----
StartTest("Sort升序不区分大小写")
Dim As WStringList sl2
sl2.Add("Zebra") : sl2.Add("apple") : sl2.Add("Monkey") : sl2.Add("bear")
sl2.Sort(False)
AssertWs("[0]", sl2[0], "apple")
AssertWs("[3]", sl2[3], "Zebra")

StartTest("Sort区分大小写")
Dim As WStringList sl2b
sl2b.Add("Zebra") : sl2b.Add("apple") : sl2b.Add("Monkey") : sl2b.Add("bear")
sl2b.Sort(True)
AssertWs("[0]大写在前", sl2b[0], "Monkey")
AssertWs("[3]小写在后", sl2b[3], "bear")

StartTest("Sort降序")
Dim As WStringList sl2c
sl2c.Add("a") : sl2c.Add("b") : sl2c.Add("c")
sl2c.Sort(False, -1)
AssertWs("降序[0]", sl2c[0], "c")

StartTest("Sort自然排序")
Dim As WStringList sl2d
sl2d.Add("item2") : sl2d.Add("item10") : sl2d.Add("item1")
sl2d.Sort(False, 1, True)
AssertWs("自然[0]", sl2d[0], "item1")
AssertWs("自然[1]", sl2d[1], "item2")
AssertWs("自然[2]", sl2d[2], "item10")

StartTest("Sorted属性")
sl2c.Sorted = False : AssertNot("False", sl2c.Sorted)
sl2c.Sorted = True  : AssertOk("True", sl2c.Sorted)

'----- 3. Insert -----
StartTest("Insert指定位置")
Dim As WStringList sl3
sl3.Add("A") : sl3.Add("C")
sl3.Insert(1, "B")
AssertWs("插入后[1]", sl3[1], "B")
AssertEq("返回索引", sl3.Insert(0, "pre"), 0)

StartTest("Insert排序插入")
Dim As WStringList sl3b
sl3b.Add("c") : sl3b.Add("a")
sl3b.Sort(False)
sl3b.Insert(-1, "b")
AssertWs("排序插入[0]", sl3b[0], "a")
AssertWs("排序插入[1]", sl3b[1], "b")
AssertWs("排序插入[2]", sl3b[2], "c")

StartTest("Insert区分大小写排序插入")
Dim As WStringList sl3c
sl3c.Add("Apple") : sl3c.Add("Zebra")
sl3c.Sort(True)
sl3c.Insert(-1, "Monkey")
AssertWs("区分大小写插入[0]", sl3c[0], "Apple")
AssertWs("区分大小写插入[1]", sl3c[1], "Monkey")

'----- 4. IndexOf / Contains / CountOf -----
StartTest("IndexOf已排序")
Dim As WStringList sl4
sl4.Add("alpha") : sl4.Add("beta") : sl4.Add("gamma") : sl4.Add("delta")
sl4.Sort(False)
AssertEq("alpha", sl4.IndexOf("alpha"), 0)
AssertEq("delta", sl4.IndexOf("delta"), 2)
AssertEq("不存在", sl4.IndexOf("omega"), -1)

StartTest("IndexOf区分大小写")
Dim As WStringList sl4b
sl4b.Add("Alpha") : sl4b.Add("beta")
sl4b.Sort(True)
AssertEq("小写alpha区分", sl4b.IndexOf("alpha", True), -1)
AssertEq("大写Alpha区分", sl4b.IndexOf("Alpha", True), 0)
AssertEq("不区分", sl4b.IndexOf("alpha", False), 0)

StartTest("IndexOf未排序线性搜索")
Dim As WStringList sl4c
sl4c.Add("z") : sl4c.Add("a") : sl4c.Add("m")
AssertEq("线性a", sl4c.IndexOf("a"), 1)

StartTest("Contains")
Dim As WStringList sl4d
sl4d.Add("dog") : sl4d.Add("cat")
Dim idx4 As Integer = -1
AssertOk("有dog", sl4d.Contains("dog", True, True, 0, idx4))
AssertOk("idx>=0", idx4 >= 0)
AssertNot("无bird", sl4d.Contains("bird", True, True, 0, idx4))
' idx4 already verified above

StartTest("CountOf")
sl4d.Add("dog")
AssertEq("dog×2", sl4d.CountOf("dog"), 2)
AssertEq("cat×1", sl4d.CountOf("cat"), 1)
AssertEq("fish×0", sl4d.CountOf("fish"), 0)

'----- 5. Exchange -----
StartTest("Exchange")
Dim As WStringList sl5
sl5.Add("first") : sl5.Add("second")
sl5.Exchange(0, 1)
AssertWs("交换后[0]", sl5[0], "second")
AssertWs("交换后[1]", sl5[1], "first")

'----- 6. Object -----
StartTest("Object存取")
Dim As WStringList sl6
Dim As Integer o1 = 42, o2 = 99
sl6.Add("k1", @o1) : sl6.Add("k2", @o2)
AssertOk("Object(0)", sl6.Object(0) = @o1)
AssertOk("Object(1)", sl6.Object(1) = @o2)
Dim As Integer o3 = 77
sl6.Object(0) = @o3
AssertOk("修改后", sl6.Object(0) = @o3)

'----- 7. IndexOfObject / ContainsObject -----
StartTest("IndexOfObject")
Dim As WStringList sl7
Dim As Integer va = 10, vb = 20
sl7.Add("x", @va) : sl7.Add("y", @vb)
AssertEq("findA", sl7.IndexOfObject(@va), 0)
AssertEq("findB", sl7.IndexOfObject(@vb), 1)
AssertEq("null", sl7.IndexOfObject(0), -1)

StartTest("ContainsObject")
AssertOk("hasA", sl7.ContainsObject(@va))
AssertNot("noNull", sl7.ContainsObject(0))

'----- 8. Remove / Clear -----
StartTest("Remove")
Dim As WStringList sl8
sl8.Add("a") : sl8.Add("b") : sl8.Add("c")
sl8.Remove(1)
AssertEq("Count=2", sl8.Count, 2)
AssertWs("[0]", sl8[0], "a")
AssertWs("[1]", sl8[1], "c")

StartTest("Remove非法索引不崩溃")
sl8.Remove(-1) : sl8.Remove(999)
AssertEq("Count不变", sl8.Count, 2)

StartTest("Clear")
sl8.Clear
AssertEq("Count=0", sl8.Count, 0)
sl8.Clear : AssertEq("再次Clear", sl8.Count, 0)

'----- 9. 事件回调 -----
StartTest("OnAdd")
ResetEvt()
Dim As WStringList sl9
sl9.OnAdd = @OnAdd_CB
sl9.Add("x") : sl9.Add("y")
AssertEq("触发2次", g_OnAdd_Calls, 2)

StartTest("OnInsert")
ResetEvt()
Dim As WStringList sl9b
sl9b.Add("a") : sl9b.OnInsert = @OnInsert_CB
sl9b.Insert(0, "x")
AssertEq("触发", g_OnInsert_Calls, 1)

StartTest("OnRemove")
ResetEvt()
Dim As WStringList sl9c
sl9c.Add("a") : sl9c.Add("b") : sl9c.OnRemove = @OnRemove_CB
sl9c.Remove(0)
AssertEq("触发", g_OnRemove_Calls, 1)

StartTest("OnExchange")
ResetEvt()
Dim As WStringList sl9d
sl9d.Add("a") : sl9d.Add("b") : sl9d.OnExchange = @OnExchange_CB
sl9d.Exchange(0, 1)
AssertEq("触发", g_OnExchange_Calls, 1)

StartTest("OnClear")
ResetEvt()
Dim As WStringList sl9e
sl9e.Add("a") : sl9e.OnClear = @OnClear_CB
sl9e.Clear
AssertEq("触发", g_OnClear_Calls, 1)

StartTest("OnChange(Sort)")
ResetEvt()
Dim As WStringList sl9f
sl9f.Add("b") : sl9f.Add("a") : sl9f.OnChange = @OnChange_CB
sl9f.Sort(False)
AssertEq("触发", g_OnChange_Calls, 1)

'----- 10. Text -----
StartTest("TextGetter")
Dim As WStringList sl10
sl10.Add("L1") : sl10.Add("L2") : sl10.Add("L3")
Dim As WString Ptr pText10 = CAllocate(256 * SizeOf(WString))
*pText10 = "L1" + Chr(13) + Chr(10) + "L2" + Chr(13) + Chr(10) + "L3"
AssertWs("Text", sl10.Text, *pText10)
Deallocate(pText10)

StartTest("TextSetter")
Dim As WStringList sl10b
sl10b.Text = "hello" + Chr(10) + "world" + Chr(10)
AssertEq("Count=2", sl10b.Count, 2)
AssertWs("[0]", sl10b[0], "hello")
AssertWs("[1]", sl10b[1], "world")

StartTest("TextSetterCRLF")
Dim As WStringList sl10c
sl10c.Text = "first" + Chr(13) + Chr(10) + "second"
AssertEq("Count=2", sl10c.Count, 2)
AssertWs("[0]", sl10c[0], "first")
AssertWs("[1]", sl10c[1], "second")

'----- 11. 操作符 Let -----
StartTest("操作符Let")
Dim As WStringList sl11
sl11 = "x" + Chr(10) + "y" + Chr(10) + "z"
AssertEq("Count=3", sl11.Count, 3)
AssertWs("[0]", sl11[0], "x")
AssertWs("[2]", sl11[2], "z")

'----- 12. MatchCase/MatchFullWords -----
StartTest("MatchCase")
Dim As WStringList sl13
AssertNot("默认False", sl13.MatchCase)
sl13.MatchCase = True : AssertOk("True", sl13.MatchCase)

StartTest("MatchFullWords")
Dim As WStringList sl13b
AssertOk("默认True", sl13b.MatchFullWords)
sl13b.MatchFullWords = False : AssertNot("False", sl13b.MatchFullWords)

'----- 13. 边界情况 -----
StartTest("空列表操作")
Dim As WStringList sl14
AssertEq("IndexOf=-1", sl14.IndexOf("x"), -1)
AssertNot("Contains=False", sl14.Contains("x", True, True, 0))
sl14.Remove(0) : AssertEq("Remove不崩溃", sl14.Count, 0)

StartTest("单元素列表")
Dim As WStringList sl14b
sl14b.Add("only")
AssertEq("IndexOf=0", sl14b.IndexOf("only"), 0)
AssertEq("不存在", sl14b.IndexOf("other"), -1)
sl14b.Sort(False) : AssertWs("Sort不崩溃", sl14b[0], "only")

StartTest("重复元素IndexOf返回第一个")
Dim As WStringList sl14c
sl14c.Add("dup") : sl14c.Add("dup") : sl14c.Add("dup")
sl14c.Sort(False) : AssertEq("第一个", sl14c.IndexOf("dup"), 0)

'----- 14. Tag -----
StartTest("Tag属性")
Dim As WStringList sl15
Dim As Integer tv = 12345
sl15.Tag = @tv
AssertOk("存取", Cast(Integer Ptr, sl15.Tag)[0] = 12345)

'----- 15. SaveToFile/LoadFromFile -----
StartTest("SaveToFile+LoadFromFile")
Dim As WStringList sl16
sl16.Add("s1") : sl16.Add("s2") : sl16.Add("s3")
sl16.SaveToFile("_wsltest_tmp.txt")
Dim As WStringList sl16b
sl16b.LoadFromFile("_wsltest_tmp.txt")
AssertEq("Count=3", sl16b.Count, 3)
AssertWs("[0]", sl16b[0], "s1")
AssertWs("[2]", sl16b[2], "s3")
Kill("_wsltest_tmp.txt")

'----- 16. 压力测试 -----
StartTest("1000元素Add+Sort+Clear")
Dim As WStringList sl17
For i As Integer = 1 To 1000
	sl17.Add("item_" & i)
Next
AssertEq("Count=1000", sl17.Count, 1000)
AssertWs("第1个", sl17[0], "item_1")
AssertWs("最后", sl17[999], "item_1000")
sl17.Sort(True)
AssertOk("排序后item_1开头", Left(sl17[0], 6) = "item_1")
sl17.Clear : AssertEq("Clear=0", sl17.Count, 0)

'----- 17. 排序前后IndexOf一致性 -----
StartTest("排序前后IndexOf一致")
Dim As WStringList sl18
sl18.Add("zzz") : sl18.Add("aaa") : sl18.Add("mmm")
AssertEq("未排序aaa", sl18.IndexOf("aaa"), 1)
sl18.Sort(False)
AssertEq("排序后aaa", sl18.IndexOf("aaa"), 0)
AssertEq("排序后mmm", sl18.IndexOf("mmm"), 1)
AssertEq("排序后zzz", sl18.IndexOf("zzz"), 2)

'----- 18. 自然排序+IndexOf/Insert一致性 -----
StartTest("自然排序IndexOf一致性")
Dim As WStringList sl19
sl19.Add("f20") : sl19.Add("f3") : sl19.Add("f100") : sl19.Add("f1")
sl19.Sort(False, 1, True)
AssertEq("f1@0", sl19.IndexOf("f1"), 0)
AssertEq("f3@1", sl19.IndexOf("f3"), 1)
AssertEq("f20@2", sl19.IndexOf("f20"), 2)
AssertEq("f100@3", sl19.IndexOf("f100"), 3)

StartTest("自然排序Insert一致性")
sl19.Insert(-1, "f5")
AssertWs("插入f5后[1]", sl19[1], "f3")
AssertWs("插入f5后[2]", sl19[2], "f5")
AssertWs("插入f5后[3]", sl19[3], "f20")

'========================== 汇总 ==========================
Print
Print "================================================"
Print "  " &  g_Passed &  " 通过(Success), " &  g_Failed &  "  失败(Failed ) (共" &  g_Passed + g_Failed &  " 项)"
Print "================================================"
Sleep(8000)
If g_Failed > 0 Then End 1 Else End 0
