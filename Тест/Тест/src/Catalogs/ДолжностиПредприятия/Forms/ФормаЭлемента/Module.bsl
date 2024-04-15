
&НаКлиенте
Процедура СписокОкладовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия    = Элементы.СписокОкладов.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("СправочникСсылка.Подразделения") Тогда
		ИмяФормыДокумента="Справочник.Подразделения.Форма.Формаэлемента";
		//ИначеЕсли ТипЗнч(СсылкаДляОткрытия)=тип("СправочникСсылка.Обязанности") Тогда
		//ИмяФормыДокумента="Справочник.Обязанности.Форма.ФормаЭлемента";
		//Возврат;
	КонецЕсли;
	
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура СписокКадровыеПриказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия    = Элементы.СписокКадровыеПриказы.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("СправочникСсылка.Сотрудники") Тогда
		ИмяФормыДокумента="Справочник.Сотрудники.Форма.Формаэлемента";
		ИначеЕсли ТипЗнч(СсылкаДляОткрытия)=тип("ДокументСсылка.КадровыйПриказ") Тогда
		ИмяФормыДокумента="Документ.КадровыйПриказ.Форма.ФормаДокумента";
		//Возврат;
	КонецЕсли;
	
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();
КонецПроцедуры





#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой(ЭтаФорма);
	СписокСотрудников.Параметры.УстановитьЗначениеПараметра("Должность", объект.Ссылка);
	СписокОбязанностей.Параметры.УстановитьЗначениеПараметра("Должность", объект.Ссылка);
	СписокКадровыеПриказы.Параметры.УстановитьЗначениеПараметра("Должность", объект.Ссылка);
	СписокОкладов.Параметры.УстановитьЗначениеПараметра("Должность", объект.Ссылка);
	//СписокНавыков.Параметры.УстановитьЗначениеПараметра("Отдел", объект.Отдел);
	
	СписокЗадачПоДолжности.Параметры.УстановитьЗначениеПараметра("Должность", объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПолучитьПараметрыДолжности();
КонецПроцедуры
&НаКлиенте
Процедура СписокОкладовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СписокОкладовОбработкаВыбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СписокОкладовОбработкаВыбораНаСервере()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЗаписатьПараметрыДолжности(ТекущийОбъект.Ссылка, Отказ);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПолучитьПараметрыДолжности();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Объект.СпособНачисленияСдельнойОплаты <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияСдельнойОплаты.ПроцентСПродажЗаВычетомОклада") 
		И Объект.СпособНачисленияСдельнойОплаты <> ПредопределенноеЗначение("Перечисление.СпособыНачисленияСдельнойОплаты.ПроцентСПродаж") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидАналитики");	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособНачисленияОкладаПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура СпособНачисленияСдельнойОплатыПриИзменении(Элемент)
	
	ПолучитьПараметрыДолжности();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ИсторияИзменений(Команда)
	ПараметрыОткрытия = Новый Структура("Отбор", Новый Структура("Должность", Объект.Ссылка));
	ОткрытьФорму("РегистрСведений.ПараметрыДолжностей.ФормаСписка", ПараметрыОткрытия, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	//Элементы = Форма.Элементы;
	//Объект = Форма.Объект;
	//
	//Элементы.ГруппаПараметрыОклада.Видимость = ЗначениеЗаполнено(Объект.СпособНачисленияОклада);
	//Элементы.ГруппаПараметрыСделки.Видимость = ЗначениеЗаполнено(Объект.СпособНачисленияСдельнойОплаты);
	//
	//ЕстьПроцентСПродаж = Объект.СпособНачисленияСдельнойОплаты = ПредопределенноеЗначение("Перечисление.СпособыНачисленияСдельнойОплаты.ПроцентСПродажЗаВычетомОклада")
	//	ИЛИ Объект.СпособНачисленияСдельнойОплаты = ПредопределенноеЗначение("Перечисление.СпособыНачисленияСдельнойОплаты.ПроцентСПродаж");
	//
	//
	//Элементы.ГруппаПроцентОтПродаж.Видимость = ЕстьПроцентСПродаж;
	//Элементы.Ставка.Видимость = Объект.СпособНачисленияСдельнойОплаты = ПредопределенноеЗначение("Перечисление.СпособыНачисленияСдельнойОплаты.ПоЧасам");
	//
	//Элементы.ВычитатьНеявкиИзСдельнойОплаты.Видимость = ЕстьПроцентСПродаж;
	
КонецПроцедуры // УправлениеФормой()

&НаСервере
Процедура ПолучитьПараметрыДолжности()
	
	Если НЕ ИспользоватьПараметрыДолжности() Тогда
		Возврат
	КонецЕсли;
	
	Срез = РегистрыСведений.ПараметрыДолжностей.СрезПоследних(КонецДня(ТекущаяДата()), Новый Структура("Должность", Объект.Ссылка));
	Если Срез.Количество() <> 0 Тогда
		Запись = Срез[Срез.Количество() - 1];
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Запись);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИспользоватьПараметрыДолжности()

	Возврат ЗначениеЗаполнено(Объект.СпособНачисленияСдельнойОплаты) ИЛИ ЗначениеЗаполнено(Объект.СпособНачисленияОклада);

КонецФункции // ИспользоватьПараметрыДолжности()


&НаСервере
Процедура ЗаписатьПараметрыДолжности(Ссылка, Отказ = Ложь)

	Если НЕ ИспользоватьПараметрыДолжности() Тогда
		Возврат
	КонецЕсли;
	
	Срез = РегистрыСведений.ПараметрыДолжностей.СрезПоследних(КонецДня(ТекущаяДата()), Новый Структура("Должность", Ссылка));
	Если Срез.Количество() <> 0 Тогда
		Запись = Срез[Срез.Количество() - 1];
		ТекущиеПараметры = Новый Структура("Процент,Ставка,ВидАналитики,Оклад,НормироватьОтработанноеВремя");
		ЗаполнитьЗначенияСвойств(ТекущиеПараметры, ЭтаФорма);
		
		
		
		Если дт_ОбщегоНазначенияКлиентСервер.СравнитьСтруктуры(ТекущиеПараметры, Запись) Тогда
			Возврат
		КонецЕсли;
		
	КонецЕсли;
		
	ЗаписатьПараметрыДолжности_Продолжение(Ссылка, Отказ);
	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьПараметрыДолжности_Продолжение(Ссылка, Отказ)

	Запись = РегистрыСведений.ПараметрыДолжностей.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, ЭтаФорма);
	Запись.Должность = Ссылка;
	Запись.Период = ТекущаяДата();
	Попытка
	
		Запись.Записать(Истина);
	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Не удалось записать параметры должности. %1",
				ОписаниеОшибки()),
			,
			,
			,
			Отказ
		);
			
	КонецПопытки;
		
	

КонецПроцедуры // ЗаписатьПараметрыДолжности_Продолжение()

&НаКлиенте
Процедура СписокСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СсылкаДляОткрытия=Элементы.СписокСотрудников.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("справочникСсылка.Сотрудники") Тогда
		ИмяФормыДокумента="справочник.Сотрудники.Форма.ФормаЭлемента";
	ИначеЕсли ТипЗнч(СсылкаДляОткрытия)=тип("ДокументСсылка.КадровыйПриказ") Тогда
		ИмяФормыДокумента="Документ.КадровыйПриказ.Форма.ФормаДокумента";
		//Возврат;
	КонецЕсли;
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура СписокОбязанностейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия=Элементы.СписокОбязанностей.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("справочникСсылка.Обязанности") Тогда
		ИмяФормыДокумента="справочник.Обязанности.Форма.ФормаЭлемента";
	Иначе
		Возврат;
	КонецЕсли;
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();
КонецПроцедуры



&НаКлиенте
Процедура ДобавитьОбязанность(Команда)
	ОписаниеВыбора = Новый ОписаниеОповещения("ОбработатьВыборОбязанности",ЭтаФорма);
	//ОткрытьФорму("");
	ОткрытьФорму("Справочник.Обязанности.ФормаВыбора",,,,,,
	ОписаниеВыбора,
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Элементы.СписокОбязанностей.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОбязанности(РезультатЗакрытия,ДопПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	ЗаписьДолжности(РезультатЗакрытия);
	Элементы.СписокОбязанностей.Обновить();
КонецПроцедуры

Процедура ЗаписьДолжности(Результат)
	Отбор = Новый Структура();
	Отбор.Вставить("Должность", Объект.Ссылка);
	ОбОбъект = Результат.ссылка.ПолучитьОбъект();
	НайденныеСтроки = ОбОбъект.СписокДолжностей.НайтиСтроки(Отбор);
	Если  НайденныеСтроки.Количество() = 0 тогда
		НоваяСтрока = ОбОбъект.СписокДолжностей.Добавить();
		НоваяСтрока.Должность = Объект.Ссылка;
		ОбОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВОтдел(Команда)
	ОписаниеВыбора = Новый ОписаниеОповещения("ОбработатьВыборОтдела",ЭтаФорма);
	//ОткрытьФорму("");
	ОткрытьФорму("Справочник.подразделения.ФормаВыбора",,,,,,
	ОписаниеВыбора,
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Элементы.СписокОбязанностей.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОтдела(РезультатЗакрытия,ДопПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	ЗаписьОтдела(РезультатЗакрытия);
	Элементы.СписокОкладов.Обновить();
КонецПроцедуры

Процедура ЗаписьОтдела(Результат)
	Отбор = Новый Структура();
	Отбор.Вставить("Должность", Объект.Ссылка);
	ОбОбъект = Результат.ссылка.ПолучитьОбъект();
	НайденныеСтроки = ОбОбъект.Должности.НайтиСтроки(Отбор);
	Если  НайденныеСтроки.Количество() = 0 тогда
		НоваяСтрока = ОбОбъект.Должности.Добавить();
		НоваяСтрока.Должность = Объект.Ссылка;
		ОбОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Элементы.СписокОкладов.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура СписокЗадачПоДолжностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия    = Элементы.СписокЗадачПоДолжности.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("ДокументСсылка.ЧекЛист") Тогда
		ИмяФормыДокумента="Документ.чекЛист.Форма.ФормаДокумента";
		ИначеЕсли ТипЗнч(СсылкаДляОткрытия)=тип("СправочникСсылка.Обязанности") Тогда
		ИмяФормыДокумента="Справочник.Обязанности.Форма.ФормаЭлемента";
		Возврат;
	КонецЕсли;
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();

КонецПроцедуры

#КонецОбласти