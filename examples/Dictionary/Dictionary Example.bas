'###############################################################################
'#  Dictionary_Ex.bas                                                          #
'#  Dictionary 全面测试程序                                                     #
'###############################################################################
#include once "mff/Dictionary.bi"

' 测试计数器
Dim Shared As Integer g_Passed = 0, g_Failed = 0, g_TestNum = 0

Sub StartTest(ByRef s As WString)
	g_TestNum += 1
	Print "-------- 测试(Testing)" &  g_TestNum &  ": " &  s & " --------"
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
	If actual = expected Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望"; expected; " 实际"; actual : g_Failed += 1
End Sub

Sub AssertWs(ByRef s As WString, ByRef actual As Const WString, ByRef expected As Const WString)
	If actual = expected Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望=["; expected; "] 实际=["; actual; "]" : g_Failed += 1
End Sub

Sub AssertOk(ByRef s As WString, cond As Boolean)
	If cond Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望True" : g_Failed += 1
End Sub

Sub AssertNot(ByRef s As WString, cond As Boolean)
	If Not cond Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望False" : g_Failed += 1
End Sub

Sub AssertPtr(ByRef s As WString, actual As Any Ptr, expected As Any Ptr)
	If actual = expected Then Pass() Else Print "  × 失败(Failed ): "; s; " 指针不匹配" : g_Failed += 1
End Sub

Sub AssertNull(ByRef s As WString, p As Any Ptr)
	If p = 0 Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望Null" : g_Failed += 1
End Sub

Sub AssertNotNull(ByRef s As WString, p As Any Ptr)
	If p <> 0 Then Pass() Else Print "  × 失败(Failed ): "; s; " 期望非Null" : g_Failed += 1
End Sub

' ========================= 事件测试辅助 =========================
Dim Shared As Integer g_OnChange_Calls = 0

Sub ResetEvt()
	g_OnChange_Calls = 0
End Sub

Sub OnChange_CB(ByRef Sender As Dictionary)
	g_OnChange_Calls += 1
End Sub

' ========================= 主测试 =========================
Print "================================================"
Print "  Dictionary 全面测试程序"
Print "================================================"
Print

'----- 1. 基本操作: Add / Count / Item(Index) / Item(Key) -----
StartTest("Add/Count: 添加3个键值对")
Dim As Dictionary d1
d1.Add("name", "John")
d1.Add("age", "30")
d1.Add("city", "New York")
AssertEq("Count=3", d1.Count, 3)

StartTest("Item(Index)取值")
AssertNotNull("Item(0)非空", d1.Item(0))
If d1.Item(0) Then AssertWs("Item(0)->Key", d1.Item(0)->Key, "name")
If d1.Item(0) Then AssertWs("Item(0)->Text", d1.Item(0)->Text, "John")

StartTest("Item(Key)取值")
AssertNotNull("Item(""age"")非空", d1.Item("age"))
If d1.Item("age") Then AssertWs("Item(""age"")->Text", d1.Item("age")->Text, "30")

StartTest("Item(不存在的Key)返回0")
AssertNull("Item(""xyz"")", d1.Item("xyz"))

StartTest("Item(Index)越界返回0")
AssertNull("Item(-1)", d1.Item(-1))
AssertNull("Item(999)", d1.Item(999))

'----- 2. Item(Index) Setter -----
StartTest("Item(Index)Setter修改条目")
Dim As Dictionary d2
d2.Add("k1", "v1")
d2.Add("k2", "v2")
Dim As DictionaryItem Ptr newItem = _New(DictionaryItem)
newItem->Key = "k1_new"
newItem->Text = "v1_new"
d2.Item(0) = newItem
If d2.Item(0) Then AssertWs("修改后->Key", d2.Item(0)->Key, "k1_new")
If d2.Item(0) Then AssertWs("修改后->Text", d2.Item(0)->Text, "v1_new")

'----- 3. Item(Key) Setter -----
StartTest("Item(Key)Setter修改已有条目")
Dim As Dictionary d3
d3.Add("color", "red")
Dim As DictionaryItem Ptr di3 = _New(DictionaryItem)
di3->Key = "color"
di3->Text = "blue"
d3.Item("color") = di3
If d3.Item("color") Then AssertWs("修改后Text=blue", d3.Item("color")->Text, "blue")

StartTest("Item(Key)Setter不存在的Key无效果")
d3.Item("size") = di3
AssertEq("Count不变", d3.Count, 1)

'----- 4. Add带Object参数 -----
StartTest("Add带Object参数")
Dim As Dictionary d4
Dim As Integer obj1 = 42, obj2 = 99
d4.Add("a", "text_a", @obj1)
d4.Add("b", "text_b", @obj2)
If d4.Item("a") Then AssertPtr("Object(a)=@obj1", d4.Item("a")->Object, @obj1)
If d4.Item("b") Then AssertPtr("Object(b)=@obj2", d4.Item("b")->Object, @obj2)

StartTest("Add默认参数(空Key/空Text/空Object)")
d4.Add("", "", 0)
AssertEq("允许空Key空Text", d4.Count, 3)

'----- 5. Set方法(不存在则Add, 存在则Update) -----
StartTest("Set新Key=Add")
Dim As Dictionary d5
d5.Set("key1", "value1")
AssertEq("Count=1", d5.Count, 1)
AssertWs("Get(key1)", d5.Get("key1"), "value1")

StartTest("Set已有Key=Update")
d5.Set("key1", "updated_value")
AssertEq("Count=1不变", d5.Count, 1)
AssertWs("Get(key1)=updated", d5.Get("key1"), "updated_value")

StartTest("Set带Object")
Dim As Integer o5 = 777
d5.Set("key2", "value2", @o5)
AssertPtr("Object(key2)=@o5", d5.GetObject("key2"), @o5)
' 更新Object
Dim As Integer o5b = 888
d5.Set("key2", "value2b", @o5b)
AssertPtr("Object更新后=@o5b", d5.GetObject("key2"), @o5b)

'----- 6. Get方法(按键/按索引) -----
StartTest("Get(Key)存在")
Dim As Dictionary d6
d6.Add("apple", "red")
d6.Add("banana", "yellow")
AssertWs("Get(apple)", d6.Get("apple"), "red")
AssertWs("Get(banana)", d6.Get("banana"), "yellow")

StartTest("Get(Key)不存在返回DefaultText")
AssertWs("Get(xyz,默认)", d6.Get("xyz", "default"), "default")

StartTest("Get(Index)存在")
AssertWs("Get(0)", d6.Get(0), "red")
AssertWs("Get(1)", d6.Get(1), "yellow")

StartTest("Get(Index)越界返回DefaultText")
AssertWs("Get(-1,默认)", d6.Get(-1, "default"), "default")
AssertWs("Get(999,默认)", d6.Get(999, "default"), "default")

'----- 7. GetText -----
StartTest("GetText按键获取文本")
AssertWs("GetText(apple)", d6.GetText("apple"), "red")
AssertWs("GetText(不存在,空)", d6.GetText("nonexist"), "")

StartTest("GetText区分大小写")
d6.Add("Apple", "GREEN")
AssertWs("不区分大小写", d6.GetText("apple", False), "red")
AssertWs("区分大小写搜Apple", d6.GetText("Apple", True), "GREEN")

'----- 8. GetKey(按文本/按对象) -----
StartTest("GetKey(按文本)")
Dim As Dictionary d8
d8.Add("k_a", "alpha")
d8.Add("k_b", "beta")
AssertWs("GetKey(alpha)", d8.GetKey("alpha"), "k_a")
AssertWs("GetKey(beta)", d8.GetKey("beta"), "k_b")
AssertWs("GetKey(不存在)", d8.GetKey("gamma"), "")

StartTest("GetKey(按对象)")
Dim As Integer oa = 100, ob = 200
Dim As Dictionary d8b
d8b.Add("first", "f", @oa)
d8b.Add("second", "s", @ob)
AssertWs("GetKey(@oa)=first", d8b.GetKey(@oa), "first")
AssertWs("GetKey(@ob)=second", d8b.GetKey(@ob), "second")
AssertWs("GetKey(0)空", d8b.GetKey(0), "")

'----- 9. GetObject(按键/按索引) -----
StartTest("GetObject(按键)")
Dim As Dictionary d9
Dim As Integer o91 = 10, o92 = 20
d9.Add("x", "x_val", @o91)
d9.Add("y", "y_val", @o92)
AssertPtr("GetObject(x)", d9.GetObject("x"), @o91)
AssertPtr("GetObject(y)", d9.GetObject("y"), @o92)
AssertNull("GetObject(不存在)", d9.GetObject("nonexist"))

StartTest("GetObject(按索引)")
AssertPtr("GetObject(0)", d9.GetObject(0), @o91)
AssertPtr("GetObject(1)", d9.GetObject(1), @o92)
AssertNull("GetObject(-1)", d9.GetObject(-1))
AssertNull("GetObject(999)", d9.GetObject(999))

'----- 10. Insert -----
StartTest("Insert头部")
Dim As Dictionary d10
d10.Add("b", "second")
d10.Insert(0, "a", "first")
AssertEq("Count=2", d10.Count, 2)
If d10.Item(0) Then AssertWs("Item(0)->Key", d10.Item(0)->Key, "a")
If d10.Item(1) Then AssertWs("Item(1)->Key", d10.Item(1)->Key, "b")

StartTest("Insert中间")
d10.Insert(1, "ab", "middle")
AssertEq("Count=3", d10.Count, 3)
If d10.Item(1) Then AssertWs("Item(1)->Key=ab", d10.Item(1)->Key, "ab")

StartTest("Insert带Object")
Dim As Integer io = 500
d10.Insert(0, "z", "z_val", @io)
AssertPtr("Object(z)", d10.GetObject("z"), @io)

'----- 11. Remove(按索引) -----
StartTest("Remove(Index)")
Dim As Dictionary d11
d11.Add("k1", "v1")
d11.Add("k2", "v2")
d11.Add("k3", "v3")
d11.Remove(1)
AssertEq("Count=2", d11.Count, 2)
If d11.Item(0) Then AssertWs("[0]Key=k1", d11.Item(0)->Key, "k1")
If d11.Item(1) Then AssertWs("[1]Key=k3", d11.Item(1)->Key, "k3")

StartTest("Remove非法索引不崩溃")
d11.Remove(-1)
d11.Remove(999)
AssertEq("Count=2不变", d11.Count, 2)

'----- 12. Exchange -----
StartTest("Exchange交换两个元素")
Dim As Dictionary d12
d12.Add("first", "1st")
d12.Add("second", "2nd")
d12.Exchange(0, 1)
If d12.Item(0) Then AssertWs("交换后[0]->Key=second", d12.Item(0)->Key, "second")
If d12.Item(1) Then AssertWs("交换后[1]->Key=first", d12.Item(1)->Key, "first")

'----- 13. Sort(按Text排序) -----
StartTest("Sort升序不区分大小写")
Dim As Dictionary d13
d13.Add("k3", "Zebra")
d13.Add("k1", "apple")
d13.Add("k2", "Monkey")
d13.Add("k4", "bear")
d13.Sort(False)
If d13.Item(0) Then AssertWs("排序后[0]Text=apple", d13.Item(0)->Text, "apple")
If d13.Item(3) Then AssertWs("排序后[3]Text=Zebra", d13.Item(3)->Text, "Zebra")

StartTest("Sort降序")
Dim As Dictionary d13b
d13b.Add("a", "x")
d13b.Add("b", "y")
d13b.Add("c", "z")
d13b.Sort(False, -1)
If d13b.Item(0) Then AssertWs("降序[0]Text=z", d13b.Item(0)->Text, "z")

StartTest("Sort自然排序")
Dim As Dictionary d13c
d13c.Add("i1", "item2")
d13c.Add("i2", "item10")
d13c.Add("i3", "item1")
d13c.Sort(False, 1, True)
If d13c.Item(0) Then AssertWs("自然[0]Text=item1", d13c.Item(0)->Text, "item1")
If d13c.Item(1) Then AssertWs("自然[1]Text=item2", d13c.Item(1)->Text, "item2")
If d13c.Item(2) Then AssertWs("自然[2]Text=item10", d13c.Item(2)->Text, "item10")

StartTest("Sort空列表不崩溃")
Dim As Dictionary d13d
d13d.Sort(False)
AssertEq("Count=0", d13d.Count, 0)

StartTest("Sort单元素不崩溃")
d13d.Add("only", "one")
d13d.Sort(False)
AssertEq("Count=1", d13d.Count, 1)

'----- 14. SortKeys(按Key排序) -----
StartTest("SortKeys升序")
Dim As Dictionary d14
d14.Add("c", "third")
d14.Add("a", "first")
d14.Add("b", "second")
d14.SortKeys(False)
If d14.Item(0) Then AssertWs("排序后[0]Key=a", d14.Item(0)->Key, "a")
If d14.Item(1) Then AssertWs("排序后[1]Key=b", d14.Item(1)->Key, "b")
If d14.Item(2) Then AssertWs("排序后[2]Key=c", d14.Item(2)->Key, "c")

StartTest("SortKeys降序")
Dim As Dictionary d14b
d14b.Add("x", "val1")
d14b.Add("y", "val2")
d14b.Add("z", "val3")
d14b.SortKeys(False, -1)
If d14b.Item(0) Then AssertWs("降序[0]Key=z", d14b.Item(0)->Key, "z")

StartTest("SortKeys空列表不崩溃")
Dim As Dictionary d14c
d14c.SortKeys(False)
AssertEq("Count=0", d14c.Count, 0)

'----- 15. Sorted/SortKeysed及相关标志位 -----
StartTest("Sort后Sorted=True, SortKeysed=False")
Dim As Dictionary d15
d15.Add("key1", "val1")
d15.Add("key2", "val2")
d15.Sort(False)
AssertOk("Sorted=True", d15.Sorted)
AssertNot("SortKeysed=False", d15.SortKeysed)

StartTest("SortKeys后Sorted=False, SortKeysed=True")
Dim As Dictionary d15b
d15b.Add("key1", "val1")
d15b.Add("key2", "val2")
d15b.SortKeys(False)
AssertNot("Sorted=False", d15b.Sorted)
AssertOk("SortKeysed=True", d15b.SortKeysed)

StartTest("Add后Sorted/SortKeysed重置为False")
Dim As Dictionary d15c
d15c.Add("k1", "v1")
d15c.Sort(False)
d15c.Add("k2", "v2")
AssertNot("Add后Sorted=False", d15c.Sorted)
AssertNot("Add后SortKeysed=False", d15c.SortKeysed)

StartTest("排序标志位(SortedMatchCase/SortedDirection等)")
AssertOk("SortedMatchCase默认False", d15.SortedMatchCase = False)
AssertEq("SortedDirection默认1", d15.SortedDirection, 1)
AssertNot("SortedNaturalSort默认False", d15.SortedNaturalSort)

'----- 16. IndexOf(按Text查找) -----
StartTest("IndexOf已排序")
Dim As Dictionary d16
d16.Add("k1", "alpha")
d16.Add("k2", "beta")
d16.Add("k3", "gamma")
d16.Add("k4", "delta")
d16.Sort(False)
AssertEq("IndexOf(alpha)", d16.IndexOf("alpha"), 0)
AssertEq("IndexOf(delta)", d16.IndexOf("delta"), 2)
AssertEq("IndexOf(omega)不存在", d16.IndexOf("omega"), -1)

StartTest("IndexOf未排序线性搜索")
Dim As Dictionary d16b
d16b.Add("k1", "zzz")
d16b.Add("k2", "aaa")
d16b.Add("k3", "mmm")
AssertEq("线性搜索aaa", d16b.IndexOf("aaa"), 1)

StartTest("IndexOf区分大小写")
Dim As Dictionary d16c
d16c.Add("k1", "Alpha")
d16c.Add("k2", "beta")
AssertEq("小写alpha区分大小写", d16c.IndexOf("alpha", True), -1)
AssertEq("大写Alpha区分大小写", d16c.IndexOf("Alpha", True), 0)
AssertEq("不区分大小写", d16c.IndexOf("alpha", False), 0)

StartTest("IndexOf从指定位置iStart开始")
Dim As Dictionary d16d
d16d.Add("k1", "dog")
d16d.Add("k2", "cat")
d16d.Add("k3", "dog")
AssertEq("从0找dog=0", d16d.IndexOf("dog", False, True, 0), 0)
AssertEq("从1找dog=2", d16d.IndexOf("dog", False, True, 1), 2)

'----- 17. IndexOfKey(按Key查找) -----
StartTest("IndexOfKey已排序(二进制搜索)")
Dim As Dictionary d17
d17.Add("apple", "v1")
d17.Add("banana", "v2")
d17.Add("cherry", "v3")
d17.SortKeys(False)
AssertEq("IndexOfKey(apple)=0", d17.IndexOfKey("apple"), 0)
AssertEq("IndexOfKey(cherry)=2", d17.IndexOfKey("cherry"), 2)
AssertEq("IndexOfKey(不存在)", d17.IndexOfKey("xyz"), -1)

StartTest("IndexOfKey未排序线性搜索")
Dim As Dictionary d17b
d17b.Add("zzz", "vz")
d17b.Add("aaa", "va")
AssertEq("线性aaa", d17b.IndexOfKey("aaa"), 1)

StartTest("IndexOfKey区分大小写")
Dim As Dictionary d17c
d17c.Add("Key", "value1")
d17c.Add("key", "value2")
d17c.SortKeys(True)
' 区分大小写: 'K'(0x4B) < 'k'(0x6B), 所以 "Key" 在 "key" 前面
AssertEq("大写Key@0", d17c.IndexOfKey("Key", , True), 0)
AssertEq("小写key@1", d17c.IndexOfKey("key", , True), 1)

'----- 18. IndexOfObject -----
StartTest("IndexOfObject")
Dim As Dictionary d18
Dim As Integer oa18 = 10, ob18 = 20, oc18 = 30
d18.Add("a", "va", @oa18)
d18.Add("b", "vb", @ob18)
d18.Add("c", "vc", @oc18)
AssertEq("IndexOfObject(@oa)=0", d18.IndexOfObject(@oa18), 0)
AssertEq("IndexOfObject(@oc)=2", d18.IndexOfObject(@oc18), 2)
AssertEq("IndexOfObject(不存在)", d18.IndexOfObject(999), -1)
AssertEq("IndexOfObject(0)", d18.IndexOfObject(0), -1)

'----- 19. Contains / ContainsKey / ContainsObject -----
StartTest("Contains(按Text)")
Dim As Dictionary d19
d19.Add("k1", "hello")
d19.Add("k2", "world")
AssertOk("Contains(hello)", d19.Contains("hello"))
AssertOk("Contains(world)", d19.Contains("world"))
AssertNot("Contains(xyz)", d19.Contains("xyz"))

StartTest("Contains区分大小写")
AssertOk("不区分", d19.Contains("HELLO", False))
AssertNot("区分", d19.Contains("HELLO", True))

StartTest("ContainsKey")
AssertOk("ContainsKey(k1)", d19.ContainsKey("k1"))
AssertNot("ContainsKey(none)", d19.ContainsKey("none"))

StartTest("ContainsObject")
Dim As Integer o19 = 123
d19.Set("k3", "v3", @o19)
AssertOk("ContainsObject(@o)", d19.ContainsObject(@o19))
AssertNot("ContainsObject(0)", d19.ContainsObject(0))

'----- 20. Clear -----
StartTest("Clear清空所有元素")
Dim As Dictionary d20
d20.Add("a", "1")
d20.Add("b", "2")
d20.Add("c", "3")
d20.Clear
AssertEq("Count=0", d20.Count, 0)

StartTest("Clear空列表不崩溃")
d20.Clear
AssertEq("Count仍0", d20.Count, 0)

'----- 21. Text属性(Getter) -----
StartTest("Text Getter")
Dim As Dictionary d21
d21.Add("name", "Tom")
d21.Add("age", "25")
' Text格式: Key + Tab + Space + Text + CRLF
Dim As WString Ptr pExpected = CAllocate(512 * SizeOf(WString))
*pExpected = "name" & Chr(9) & " " & "Tom" & Chr(13) & Chr(10) & "age" & Chr(9) & " " & "25"
AssertWs("Text Getter", d21.Text, *pExpected)
Deallocate(pExpected)

StartTest("Text Getter空字典")
Dim As Dictionary d21b
AssertWs("空字典Text为空", d21b.Text, "")

'----- 22. Text属性(Setter) -----
StartTest("Text Setter 用LF分隔")
Dim As Dictionary d22
d22.Text = "city" & Chr(9) & " " & "NYC" & Chr(10) & "country" & Chr(9) & " " & "USA"
AssertEq("Count=2", d22.Count, 2)
If d22.Item(0) Then AssertWs("[0]Key=city", d22.Item(0)->Key, "city")
If d22.Item(0) Then AssertWs("[0]Text=NYC", d22.Item(0)->Text, "NYC")
If d22.Item(1) Then AssertWs("[1]Key=country", d22.Item(1)->Key, "country")

StartTest("Text Setter CRLF分隔")
Dim As Dictionary d22b
d22b.Text = "first" & Chr(9) & " " & "1st" & Chr(13) & Chr(10) & "second" & Chr(9) & " " & "2nd"
AssertEq("Count=2", d22b.Count, 2)
If d22b.Item(0) Then AssertWs("[0]Key=first", d22b.Item(0)->Key, "first")
If d22b.Item(1) Then AssertWs("[1]Key=second", d22b.Item(1)->Key, "second")

'----- 23. 操作符 Let -----
StartTest("操作符Let(=)等价TextSetter")
Dim As Dictionary d23
d23 = "x" & Chr(9) & " " & "1" & Chr(10) & "y" & Chr(9) & " " & "2" & Chr(10) & "z" & Chr(9) & " " & "3"
AssertEq("Count=3", d23.Count, 3)
If d23.Item(0) Then AssertWs("[0]Key=x", d23.Item(0)->Key, "x")
If d23.Item(2) Then AssertWs("[2]Key=z", d23.Item(2)->Key, "z")

'----- 24. 操作符 [] -----
StartTest("操作符[]取值")
Dim As Dictionary d24
d24.Add("hello", "world")
d24.Add("foo", "bar")
AssertWs("d24[""hello""]", d24["hello"], "world")
AssertWs("d24[""foo""]", d24["foo"], "bar")

StartTest("操作符[]不存在的Key返回空")
AssertWs("d24[""xyz""]", d24["xyz"], "")

'----- 25. Tag属性 -----
StartTest("Tag属性")
Dim As Dictionary d25
Dim As Integer tagVal = 54321
d25.Tag = @tagVal
AssertOk("Tag存取", Cast(Integer Ptr, d25.Tag)[0] = 54321)

'----- 26. Count属性Setter(无效果,只读) -----
StartTest("Count Setter无效果(只读保护)")
Dim As Dictionary d26
d26.Add("a", "1")
d26.Count = 999
AssertEq("Count不变", d26.Count, 1)

'----- 27. SaveToFile / LoadFromFile -----
StartTest("SaveToFile+LoadFromFile")
Dim As Dictionary d27
d27.Add("key_a", "value_a")
d27.Add("key_b", "value_b")
d27.Add("key_c", "value_c")
d27.SaveToFile("_dictest_tmp.txt")

Dim As Dictionary d27b
d27b.LoadFromFile("_dictest_tmp.txt")
AssertEq("Count=3", d27b.Count, 3)
If d27b.Item("key_a") Then AssertWs("key_a不变", d27b.Item("key_a")->Text, "value_a")
If d27b.Item("key_b") Then AssertWs("key_b不变", d27b.Item("key_b")->Text, "value_b")
If d27b.Item("key_c") Then AssertWs("key_c不变", d27b.Item("key_c")->Text, "value_c")
Kill("_dictest_tmp.txt")

StartTest("SaveToFile空字典")
Dim As Dictionary d27c
d27c.SaveToFile("_dictest_empty.txt")
' 文件可能不存在或为空
Dim As Dictionary d27d
d27d.LoadFromFile("_dictest_empty.txt")
AssertEq("Count=0", d27d.Count, 0)
Kill("_dictest_empty.txt")

'----- 28. OnChange事件 -----
StartTest("OnChange: Add触发")
ResetEvt()
Dim As Dictionary d28
d28.OnChange = @OnChange_CB
d28.Add("x", "y")
AssertEq("Add触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Sort触发")
ResetEvt()
Dim As Dictionary d28b
d28b.OnChange = @OnChange_CB
d28b.Add("b", "2")
d28b.Add("a", "1")
ResetEvt() ' 重置计数
d28b.Sort(False)
' Sort内部Exchange也会触发OnChange,加上Sort自身的OnChange
AssertOk("Sort触发OnChange(至少1次)", g_OnChange_Calls >= 1)

StartTest("OnChange: Remove触发")
ResetEvt()
Dim As Dictionary d28c
d28c.OnChange = @OnChange_CB
d28c.Add("a", "1")
ResetEvt()
d28c.Remove(0)
AssertEq("Remove触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Exchange触发")
ResetEvt()
Dim As Dictionary d28d
d28d.OnChange = @OnChange_CB
d28d.Add("a", "1")
d28d.Add("b", "2")
ResetEvt()
d28d.Exchange(0, 1)
AssertEq("Exchange触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Clear触发")
ResetEvt()
Dim As Dictionary d28e
d28e.OnChange = @OnChange_CB
d28e.Add("a", "1")
ResetEvt()
d28e.Clear
AssertEq("Clear触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Insert触发")
ResetEvt()
Dim As Dictionary d28f
d28f.OnChange = @OnChange_CB
d28f.Add("a", "1")
ResetEvt()
d28f.Insert(0, "b", "2")
AssertEq("Insert触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Text Setter触发")
ResetEvt()
Dim As Dictionary d28g
d28g.OnChange = @OnChange_CB
d28g.Text = "k" & Chr(9) & " " & "v" & Chr(10)
AssertEq("Text Setter触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: LoadFromFile触发")
ResetEvt()
Dim As Dictionary d28h
d28h.OnChange = @OnChange_CB
d28h.Add("tmp", "tmp")
d28h.SaveToFile("_dictest_evt.txt")
ResetEvt()
d28h.LoadFromFile("_dictest_evt.txt")
AssertEq("LoadFromFile触发OnChange", g_OnChange_Calls, 1)
Kill("_dictest_evt.txt")

StartTest("OnChange: Item(Index)Setter触发")
ResetEvt()
Dim As Dictionary d28i
d28i.OnChange = @OnChange_CB
d28i.Add("a", "1")
ResetEvt()
Dim As DictionaryItem Ptr di28 = _New(DictionaryItem)
di28->Key = "a"
di28->Text = "changed"
d28i.Item(0) = di28
AssertEq("Item(Index)Setter触发OnChange", g_OnChange_Calls, 1)

StartTest("OnChange: Set触发")
ResetEvt()
Dim As Dictionary d28j
d28j.OnChange = @OnChange_CB
ResetEvt()
d28j.Set("k", "v")
' Set内部Add触发1次, Set自身再触发1次(双触发设计)
AssertEq("Set触发OnChange", g_OnChange_Calls, 2)

'----- 29. DictionaryItem.Key/Text Setter/Getter -----
StartTest("DictionaryItem.Key Setter/Getter")
Dim As DictionaryItem Ptr di29 = _New(DictionaryItem)
di29->Key = "test_key"
AssertWs("Key取值", di29->Key, "test_key")
di29->Key = "updated_key"
AssertWs("Key更新", di29->Key, "updated_key")

StartTest("DictionaryItem.Text Setter/Getter")
di29->Text = "test_text"
AssertWs("Text取值", di29->Text, "test_text")
di29->Text = "updated_text"
AssertWs("Text更新", di29->Text, "updated_text")

StartTest("DictionaryItem.Object直接赋值")
Dim As Integer o29 = 111
di29->Object = @o29
AssertPtr("Object=@o29", di29->Object, @o29)

StartTest("DictionaryItem默认构造函数")
Dim As DictionaryItem Ptr di29b = _New(DictionaryItem)
AssertWs("默认Key为空", di29b->Key, "")
AssertWs("默认Text为空", di29b->Text, "")
AssertNull("默认Object为空", di29b->Object)

_Delete(di29)
_Delete(di29b)

'----- 30. 边界情况 -----
StartTest("空字典所有查询返回安全默认值")
Dim As Dictionary d30
AssertEq("IndexOf=-1", d30.IndexOf("any"), -1)
AssertEq("IndexOfKey=-1", d30.IndexOfKey("any"), -1)
AssertEq("IndexOfObject=-1", d30.IndexOfObject(123), -1)
AssertNot("Contains=False", d30.Contains("any"))
AssertNot("ContainsKey=False", d30.ContainsKey("any"))
AssertNot("ContainsObject=False", d30.ContainsObject(123))
AssertWs("Get(Key)=默认", d30.Get("any", "def"), "def")
AssertWs("Get(Index)=默认", d30.Get(0, "def"), "def")
AssertWs("GetText=空", d30.GetText("any"), "")
AssertNull("GetObject(Key)=0", d30.GetObject("any"))
AssertNull("GetObject(Index)=0", d30.GetObject(0))
AssertWs("GetKey(Text)=空", d30.GetKey("any"), "")
AssertWs("GetKey(Object)=空", d30.GetKey(0), "")

StartTest("单元素字典")
Dim As Dictionary d30b
d30b.Add("single", "one")
AssertEq("Count=1", d30b.Count, 1)
AssertEq("IndexOf(one)=0", d30b.IndexOf("one"), 0)
AssertEq("IndexOfKey(single)=0", d30b.IndexOfKey("single"), 0)
d30b.Sort(False)
AssertEq("Sort后Count=1", d30b.Count, 1)
If d30b.Item(0) Then AssertWs("Sort后不变", d30b.Item(0)->Text, "one")

'----- 31. 压力测试 -----
StartTest("1000元素Add+Sort+Clear")
Dim As Dictionary d31
For i As Integer = 1 To 1000
	d31.Add("key_" & i, "value_" & i)
Next
AssertEq("Count=1000", d31.Count, 1000)
If d31.Item(0) Then AssertWs("第1个Key", d31.Item(0)->Key, "key_1")
If d31.Item(999) Then AssertWs("最后Key", d31.Item(999)->Key, "key_1000")
d31.SortKeys(False)
AssertOk("SortKeys后item key_1在前", Left(d31.Item(0)->Key, 4) = "key_")
d31.Clear
AssertEq("Clear后Count=0", d31.Count, 0)

StartTest("字典作为对象字典使用(模拟映射)")
Dim As Dictionary d32
' 模拟一个对象字典: 根据ID查找数据
Dim As Integer data1 = 1001, data2 = 1002, data3 = 1003
d32.Add("id_001", "Alice", @data1)
d32.Add("id_002", "Bob", @data2)
d32.Add("id_003", "Charlie", @data3)
AssertEq("Count=3", d32.Count, 3)
AssertWs("id_002名字=Bob", d32.Get("id_002"), "Bob")
AssertPtr("id_002对象=@data2", d32.GetObject("id_002"), @data2)
AssertOk("ContainsKey(id_003)=True", d32.ContainsKey("id_003"))
AssertOk("Contains(Alice)=True", d32.Contains("Alice"))

'----- 32. Sort和SortKeys排序结果对比 -----
StartTest("Sort对Text排序 vs SortKeys对Key排序")
Dim As Dictionary d33
d33.Add("zebra", "z_text")
d33.Add("apple", "a_text")
d33.Add("monkey", "m_text")
' 按Text排序
d33.Sort(False)
If d33.Item(0) Then AssertWs("Sort后[0]Text=a_text", d33.Item(0)->Text, "a_text")
' 按Key排序
d33.SortKeys(False)
If d33.Item(0) Then AssertWs("SortKeys后[0]Key=apple", d33.Item(0)->Key, "apple")
If d33.Item(0) Then AssertWs("SortKeys后[0]Text=a_text", d33.Item(0)->Text, "a_text")

'----- 33. 重复Key处理 -----
StartTest("重复Key的处理(IndexOfKey返回第一个)")
Dim As Dictionary d34
d34.Add("dup", "first")
d34.Add("dup", "second")
AssertEq("Count=2", d34.Count, 2)
Dim As Integer idxDup = d34.IndexOfKey("dup")
AssertEq("IndexOfKey(""dup"")找到第一个", idxDup, 0)

'----- 34. IndexOf bMatchFullWords参数 -----
StartTest("IndexOf 未排序线性搜索")
Dim As Dictionary d35
d35.Add("k1", "abcdef")
d35.Add("k2", "abc")
' 未排序时走线性搜索, bMatchFullWords不传给StringsCompare, 只做精确匹配
AssertEq("精确匹配abc@1", d35.IndexOf("abc", False, True), 1)
AssertEq("精确匹配abc@1(同)", d35.IndexOf("abc", False, False), 1)
AssertEq("abcdef@0", d35.IndexOf("abcdef"), 0)

'========================== 汇总 ==========================
Print
Print "================================================"
Print "  "; g_Passed; " 通过(Success), "; g_Failed; " 失败(Failed ) (共"; g_Passed + g_Failed; " 项)"
Print "================================================"
Sleep(8000)
If g_Failed > 0 Then End 1 Else End 0
