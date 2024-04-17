#Область ОбработчикиСобытийФормы



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	

	
	ОбновитьСписки();
	ОбновитьПоказатели();
	
	///+ГомзМА 11.07.2023
	//Динамический список Список
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;

	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСумма.ТекстПодвала 	=  Формат(Результат.Итог("Сумма"), "ЧДЦ=0; ЧН=-");
	
	
	//Динамический список СписокРасходы
	Схема = Элементы.СписокРасходы.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокРасходы.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	//Элементы.СписокРасходыСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;

	
	//Элементы.СписокРасходыСумма.ТекстПодвала 	=  Формат(Результат.Итог("Сумма"), "ЧДЦ=0; ЧН=-");
	///-ГомзМА 11.07.2023
	
	ДоступныРасходы = ПравоДоступа("Просмотр", Метаданные.Документы.Расходы);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры



&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ВидимостьЭлементовНаСервере();
	РассчетСрокаРемонтаИВремениДоСдачиНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры



&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьСписки();
КонецПроцедуры




#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список



#КонецОбласти

#Область ОбработчикиКомандФормы


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписки() Экспорт
	
	Ссылка = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка, Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Проект", 
			Ссылка, // Значение отбора
			ВидСравненияКомпоновкиДанных.Равно,, Истина
	);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокРасходы, 
			"Проект", 
			Ссылка, // Значение отбора
			ВидСравненияКомпоновкиДанных.Равно,, Истина
	);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПоказатели() Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат
	КонецЕсли;
	
	Показатели = Справочники.ПроектыРазработки.ПолучитьПоказателиПроекта(Объект.Ссылка);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Показатели);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	//Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаРасходы.Видимость = Форма.ДоступныРасходы;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриемаПриИзменении(Элемент)
	
	РассчетСрокаРемонтаИВремениДоСдачиНаСервере();  
	
КонецПроцедуры



&НаКлиенте
Процедура ДатаНачалаРаботыПриИзменении(Элемент)
	
	РассчетСрокаРемонтаИВремениДоСдачиНаСервере();// Добавил пересчет Даты сдачи при изменении
	
КонецПроцедуры



&НаКлиенте
Процедура ДатаСдачиПриИзменении(Элемент)
	
	РассчетСрокаРемонтаИВремениДоСдачиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	ВидимостьЭлементовНаСервере();
	
КонецПроцедуры


&НаСервере
Процедура ВидимостьЭлементовНаСервере()

	///+ГомзМА 09.03.2023
	Если Объект.Состояние = Перечисления.СостоянияЗаказНаряда.ВРаботе Тогда
		Элементы.ДатаПриема.Видимость 		= Истина;
		Элементы.ДатаСдачи.Видимость 		= Истина;
		Элементы.СрокРемонта.Видимость 		= Истина;
		Элементы.ОстатокДоСдачи.Видимость 	= Истина;
		Элементы.ДатаНачалаРаботы.Видимость = Истина; // Добавил
	ИначеЕсли Объект.Состояние = Перечисления.СостоянияЗаказНаряда.Выполнен Тогда
		Элементы.ДатаПриема.Видимость 		= Ложь;
		Элементы.ДатаСдачи.Видимость 		= Ложь;
		Элементы.СрокРемонта.Видимость 		= Ложь;
		Элементы.ОстатокДоСдачи.Видимость 	= Ложь;
	КонецЕсли;
	///-ГомзМА 09.03.2023

КонецПроцедуры

&НаСервере
Процедура РассчетСрокаРемонтаИВремениДоСдачиНаСервере()
	
	///+ГомзМА 09.03.2023
	//Если Объект.Состояние = Перечисления.СостоянияЗаказНаряда.ВРаботе Тогда
		//Если Объект.ДатаПриема <> '00010101' И Объект.ДатаСдачи <> '00010101' Тогда
			//Объект.СрокРемонта 	= (Объект.ДатаСдачи - Объект.ДатаПриема) / 86400 + 1;     
			//Объект.ВремяДоСдачи = Цел((Объект.ДатаСдачи - ТекущаяДатаСеанса()) / 86400 + 1);
		//КонецЕсли;
	//КонецЕсли;
	///-ГомзМА 09.03.2023
	
	
	//+ГомзМА 09.03.2023
	Если Объект.Состояние = Перечисления.СостоянияЗаказНаряда.ВРаботе Тогда
		Если Объект.ДатаНачалаРаботы <> '00010101' И Объект.ДатаСдачи <> '00010101' Тогда
			Объект.СрокРемонта 	= (Объект.ДатаСдачи - Объект.ДатаНачалаРаботы) / 86400 + 1;     
			Объект.ВремяДоСдачи = Цел((Объект.ДатаСдачи - ТекущаяДатаСеанса()) / 86400 + 1);
		КонецЕсли;
	КонецЕсли;
	//-ГомзМА 09.03.2023
	
	

КонецПроцедуры

&НаСервере
Процедура ВинКодПриИзмененииНаСервере()
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказНаряд.Ссылка КАК Ссылка,
	               |	ЗаказНаряд.ВинКод КАК ВинКод
	               |ИЗ
	               |	Документ.ЗаказНаряд КАК ЗаказНаряд
	               |ГДЕ
	               |	ЗаказНаряд.Проект = &Проект";
	Запрос.УстановитьПараметр("Проект",Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если выборка.Количество() > 0 Тогда
		Пока выборка.Следующий() Цикл
			ОбъектЗН = Выборка.ссылка.Получитьобъект();
			ОбъектЗН.ВинКод = объект.ВинКод;
			ОбъектЗН.записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВинКодПриИзменении(Элемент)
	ВинКодПриИзмененииНаСервере();
КонецПроцедуры


#КонецОбласти