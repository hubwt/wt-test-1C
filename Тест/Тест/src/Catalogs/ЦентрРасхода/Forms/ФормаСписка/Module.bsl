
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	
	
	Список.Параметры.УстановитьЗначениеПараметра("Дата1",Период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("Дата2",Период.ДатаОкончания); 
	
	Дата11 = Период.ДатаНачала; 
	Дата22 = Период.ДатаОкончания; 
	
	ЗаписатьКонстантуПериод(Дата11,Дата22) ; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаписатьКонстантуПериод(Дата11,Дата22) 
	
	Константы.ПериодСписокЦентРасходаДата1.Установить(Дата11);
	Константы.ПериодСписокЦентРасходаДата2.Установить(Дата22);

КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
//	Дата1 =	ПолучитьКонстантуДата1();
//	Дата2 = ПолучитьКонстантуДата2();
//	
//	Если Дата1 < Дата(2011,1,1) ИЛИ Дата2 < Дата(2011,1,1) ТОГДА 
//		
//		Дата1 = НачалоМесяца (ТекущаяДата());  
//		Дата2 = КонецМесяца (ТекущаяДата()); 
//	
//		Сообщение = Новый СообщениеПользователю();
//		Сообщение.Текст = "Данные за текущий месяц";
//		Сообщение.Сообщить();
//	
//	КонецЕСли; 
//	
//	Список.Параметры.УстановитьЗначениеПараметра("Дата1",Дата1);
//	Список.Параметры.УстановитьЗначениеПараметра("Дата2",Дата2);
//	СписокФилиалы.Параметры.УстановитьЗначениеПараметра("Дата1",Дата1);
//	СписокФилиалы.Параметры.УстановитьЗначениеПараметра("Дата2",Дата2);
//	 
//	ЗаполнитьПодвал(); 
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ОтделыСтраница; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата1 =	ПолучитьКонстантуДата1();
	Дата2 = ПолучитьКонстантуДата2();
	
	Если Дата1 < Дата(2011,1,1) ИЛИ Дата2 < Дата(2011,1,1) ТОГДА 
		
		Дата1 = НачалоМесяца (ТекущаяДата());  
		Дата2 = КонецМесяца (ТекущаяДата()); 
	
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Данные за текущий месяц";
		Сообщение.Сообщить();
	
	КонецЕСли; 
	
	
	Список.Параметры.УстановитьЗначениеПараметра("Дата1",Дата1);
	Список.Параметры.УстановитьЗначениеПараметра("Дата2",Дата2);
	
	СписокФилиалы.Параметры.УстановитьЗначениеПараметра("Дата1",Дата1);
	СписокФилиалы.Параметры.УстановитьЗначениеПараметра("Дата2",Дата2);
	 
	ЗаполнитьПодвал(); 
	ЗаполнитьПодвалСписокФилиалы(); 
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьКонстантуДата1();
	
	Дата1 = Константы.ПериодСписокЦентРасходаДата1.Получить(); 
	Возврат Дата1; 

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКонстантуДата2();
	
	Дата2 = Константы.ПериодСписокЦентРасходаДата2.Получить(); 
	Возврат Дата2; 

КонецФункции

Процедура ЗаполнитьПодвал()
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаЗП.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаОкладов.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаБонусовИПремий.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаРасходов.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.Обязательные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;	
	ЭтотОбъект.ЭтаФорма.Элементы.Переменные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.НеПредвиденные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.ОбщийРасход.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.Выручка.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.Прибыль.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаЗП.ТекстПодвала =  Формат(Результат.Итог("СуммаЗП"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаОкладов.ТекстПодвала =  Формат(Результат.Итог("СуммаОкладов"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаБонусовИПремий.ТекстПодвала =  Формат(Результат.Итог("СуммаБонусовИПремий"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СуммаРасходов.ТекстПодвала =  Формат(Результат.Итог("СуммаРасходов"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.Обязательные.ТекстПодвала =  Формат(Результат.Итог("Обязательные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.Переменные.ТекстПодвала =  Формат(Результат.Итог("Переменные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.НеПредвиденные.ТекстПодвала =  Формат(Результат.Итог("НеПредвиденные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.ОбщийРасход.ТекстПодвала =  Формат(Результат.Итог("ОбщийРасход"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.Выручка.ТекстПодвала =  Формат(Результат.Итог("Выручка"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.Прибыль.ТекстПодвала =  Формат(Результат.Итог("Прибыль"),"ЧДЦ=0; ЧН=-");

КонецПроцедуры

Процедура ЗаполнитьПодвалСписокФилиалы()
	
	Схема = Элементы.СписокФилиалы.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокФилиалы.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаЗП.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаОкладов.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаБонусовИПремий.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаРасходов.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыОбязательные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыПеременные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыНеПредвиденные.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыОбщийРасход.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыВыручка.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыПрибыль.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаЗП.ТекстПодвала =  Формат(Результат.Итог("СуммаЗП"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаОкладов.ТекстПодвала =  Формат(Результат.Итог("СуммаОкладов"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаБонусовИПремий.ТекстПодвала =  Формат(Результат.Итог("СуммаБонусовИПремий"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыСуммаРасходов.ТекстПодвала =  Формат(Результат.Итог("СуммаРасходов"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыОбязательные.ТекстПодвала =  Формат(Результат.Итог("Обязательные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыПеременные.ТекстПодвала =  Формат(Результат.Итог("Переменные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыНеПредвиденные.ТекстПодвала =  Формат(Результат.Итог("НеПредвиденные"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыОбщийРасход.ТекстПодвала =  Формат(Результат.Итог("ОбщийРасход"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыВыручка.ТекстПодвала =  Формат(Результат.Итог("Выручка"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокФилиалыПрибыль.ТекстПодвала =  Формат(Результат.Итог("Прибыль"),"ЧДЦ=0; ЧН=-");

КонецПроцедуры

