&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСписки(НачалоМесяца(ТекущаяДата()),ТекущаяДата());

КонецПроцедуры
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ОбновитьСписки(период.ДатаНачала,период.ДатаОкончания); 	

КонецПроцедуры

///// Команды поступления//////////////////////
&НаКлиенте
Процедура ПоступленияВсе(Команда)
		
	Элементы.ПоступленияВсе.ЦветФона 	= Новый Цвет (190,255,150);
	Элементы.ПоступленияОтдел.ЦветФона 	= Новый Цвет (252,250,235);

	
	Элементы.СписокПоступления.Видимость = Истина; 
	Элементы.СписокПоступленияОтдел1.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура ПоступленияОтдел(Команда)
	
	Элементы.ПоступленияВсе.ЦветФона 	= Новый Цвет (252,250,235);
	Элементы.ПоступленияОтдел.ЦветФона 	= Новый Цвет (190,255,150);
	
	Элементы.СписокПоступления.Видимость = Ложь; 
	Элементы.СписокПоступленияОтдел1.Видимость = Истина; 
КонецПроцедуры

//Команды Оклад//////////////////////////////
&НаКлиенте
Процедура ОкладВсе(Команда)
	
	Элементы.ОкладВсе.ЦветФона 	= Новый Цвет (190,255,150);
	Элементы.ОкладОтдел.ЦветФона 	= Новый Цвет (252,250,235);
	Элементы.ОкладСтатья.ЦветФона 	= Новый Цвет (252,250,235);
	
	Элементы.СписокОклад.Видимость = Истина; 
	Элементы.СписокОкладОтдел1.Видимость = ложь; 
	Элементы.СписокОкладСтатья1.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура ОкладОтдел(Команда)
	
	Элементы.ОкладВсе.ЦветФона 	= Новый Цвет (252,250,235);
	Элементы.ОкладОтдел.ЦветФона 	= Новый Цвет (190,255,150);
	Элементы.ОкладСтатья.ЦветФона 	= Новый Цвет (252,250,235);
	
	Элементы.СписокОклад.Видимость = ложь; 
	Элементы.СписокОкладОтдел1.Видимость = Истина; 
	Элементы.СписокОкладСтатья1.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура ОкладСтатья(Команда)
	
	Элементы.ОкладВсе.ЦветФона 	= Новый Цвет (252,250,235);
	Элементы.ОкладОтдел.ЦветФона 	= Новый Цвет (252,250,235);
	Элементы.ОкладСтатья.ЦветФона 	= Новый Цвет (190,255,150);
	
	Элементы.СписокОклад.Видимость = ложь; 
	Элементы.СписокОкладОтдел1.Видимость = ложь; 
	Элементы.СписокОкладСтатья1.Видимость = Истина; 
КонецПроцедуры

//Команды Бонусы//////////////////////////////
&НаКлиенте
Процедура БонусыВсе(Команда)
	
	Элементы.БонусыВсе.ЦветФона 		= Новый Цвет (190,255,150);
	Элементы.БонусыОтдел.ЦветФона 		= Новый Цвет (252,250,235);
	Элементы.БонусыСтатьи.ЦветФона 	= Новый Цвет (252,250,235);
	
	Элементы.СписокБонусы.Видимость = Истина; 
	Элементы.СписокБонусыОтдел1.Видимость = ложь; 
	Элементы.СписокБонусыСтатья1.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура БонусыОтдел(Команда)
	
	Элементы.БонусыВсе.ЦветФона 		= Новый Цвет (252,250,235);
	Элементы.БонусыОтдел.ЦветФона 		= Новый Цвет (190,255,150);
	Элементы.БонусыСтатьи.ЦветФона 	= Новый Цвет (252,250,235);
	
	Элементы.СписокБонусы.Видимость = ложь; 
	Элементы.СписокБонусыОтдел1.Видимость = Истина; 
	Элементы.СписокБонусыСтатья1.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура БонусыСтатьи(Команда)
	
	Элементы.БонусыВсе.ЦветФона 		= Новый Цвет (252,250,235);
	Элементы.БонусыОтдел.ЦветФона 		= Новый Цвет (252,250,235);
	Элементы.БонусыСтатьи.ЦветФона 	= Новый Цвет (190,255,150);
	
	Элементы.СписокБонусы.Видимость = ложь; 
	Элементы.СписокБонусыОтдел1.Видимость = ложь; 
	Элементы.СписокБонусыСтатья1.Видимость = Истина; 
КонецПроцедуры
&НаСервере
Функция ОбновитьСписки(Дата1 = Неопределено,Дата2 = Неопределено)
	
	СписокПоступления.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокПоступления.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
	СписокПоступленияОтдел.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокПоступленияОтдел.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);

	СписокОклад.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокОклад.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
	СписокОкладОтдел.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокОкладОтдел.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
	СписокОкладСтатья.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокОкладСтатья.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);


	СписокБонусы.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокБонусы.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
	СписокБонусыОтдел.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокБонусыОтдел.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
	СписокБонусыСтатья.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
	СписокБонусыСтатья.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);

	ЗаполнитьПодвалы();

КонецФункции

///Заполняем подвалы
Процедура ЗаполнитьПодвалы()
		
		ЗаполнитьПодвалСписокПоступления(); 
		ЗаполнитьПодвалСписокПоступленияОтдел1(); 

	ФактОклад = ЗаполнитьПодвалСписокСписокОклад(); 
	ЗаполнитьПодвалСписокСписокОкладОтдел1();
	ЗаполнитьПодвалСписокСписокОкладСтатья1();
	
	ФактБонус = ЗаполнитьПодвалСписокСписокБонусы();
		ЗаполнитьПодвалСписокСписокБонусыОтдел1();
		ЗаполнитьПодвалСписокСписокБонусыСтатья1(); 
		
	Факт = ФактОклад + ФактБонус; 
КонецПроцедуры

&НаКлиенте
Процедура ПроцентОтВыручкиПриИзменении(Элемент)
	План = 	ЗаполнитьПодвалСписокПоступления() * ПроцентОтВыручки / 100; 
КонецПроцедуры


Функция ЗаполнитьПодвалСписокПоступления()
	
	Схема = Элементы.СписокПоступления.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокПоступления.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	

	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокПоступленияСуммаДокумента.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокПоступленияСуммаДокумента.ТекстПодвала =  Формат(Результат.Итог("СуммаДокумента"),"ЧДЦ=0; ЧН=-");
 
	Возврат Результат.Итог("СуммаДокумента"); 
КонецФункции

Процедура ЗаполнитьПодвалСписокПоступленияОтдел1()
	
	Схема = Элементы.СписокПоступленияОтдел1.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокПоступленияОтдел1.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокПоступленияОтделСуммаДокумента.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокПоступленияОтделСуммаДокумента.ТекстПодвала =  Формат(Результат.Итог("СуммаДокумента"),"ЧДЦ=0; ЧН=-");
 
КонецПроцедуры

Функция ЗаполнитьПодвалСписокСписокОклад()
	
	Схема = Элементы.СписокОклад.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокОклад.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 	
 	Возврат Результат.Итог("Сумма");
КонецФункции

Процедура ЗаполнитьПодвалСписокСписокОкладОтдел1()
	
	Схема = Элементы.СписокОкладОтдел1.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокОкладОтдел1.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладОтделСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладОтделСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 
КонецПроцедуры

Процедура ЗаполнитьПодвалСписокСписокОкладСтатья1()
	
	Схема = Элементы.СписокОкладСтатья1.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокОкладСтатья1.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладСтатьяСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокОкладСтатьяСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 
КонецПроцедуры

Функция ЗаполнитьПодвалСписокСписокБонусы()
	
	Схема = Элементы.СписокБонусы.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокБонусы.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 	
 	Возврат Результат.Итог("Сумма"); 
КонецФункции

Процедура ЗаполнитьПодвалСписокСписокБонусыОтдел1()
	
	Схема = Элементы.СписокБонусыОтдел1.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокБонусыОтдел1.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыОтделСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыОтделСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 
КонецПроцедуры

Процедура ЗаполнитьПодвалСписокСписокБонусыСтатья1()
	
	Схема = Элементы.СписокБонусыСтатья1.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокБонусыСтатья1.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыСтатьяСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокБонусыСтатьяСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
 
КонецПроцедуры