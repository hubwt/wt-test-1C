#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//Если Параметры.Сотрудник  <> Справочники.Сотрудники.ПустаяСсылка() Тогда
	//	Объект.Сотрудник = Параметры.Сотрудник;
	//КонецЕсли;
	доступностьОтделов();
	заполнениеСпискаЦФО();
    заполнениеСпискаОтделов();
    заполнениеСпискаДолжностей();
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
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Справочник.Подразделения.Форма.ФормаВыбора" Тогда
		Элементы.Сотрудники.ТекущиеДанные.Подразделение = ВыбранноеЗначение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Сотрудники

&НаКлиенте
Процедура СотрудникиПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//ПараметрыОткрытия = Новый Структура();
	//ПараметрыОткрытия.Вставить("ЦФО", Объект.ЦФО);
	//ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Сотрудники.ТекущиеДанные.Подразделение);
	//
	//ОткрытьФорму("Справочник.Подразделения.Форма.ФормаВыбора", ПараметрыОткрытия, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры




#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		
		Элементы.Сотрудники.ТекущиеДанные.Дата = Объект.Дата;
		
	КонецЕсли;
	
КонецПроцедуры


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

&НаСервере
Процедура заполнениеСпискаЦФО()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Подразделения.Ссылка КАК Ссылка,
	               |	Подразделения.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	Подразделения.Город = &Город";
	Запрос.УстановитьПараметр("Город",Объект.Город);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.ЦФО.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.ЦФО.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура заполнениеСпискаОтделов()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Подразделения.Ссылка КАК Ссылка,
	               |	Подразделения.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	Подразделения.Родитель = &Родитель";
	Запрос.УстановитьПараметр("Родитель",Объект.ЦФО);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.Отдел.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.Отдел.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура заполнениеСпискаДолжностей()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДолжностиПредприятия.Ссылка КАК Ссылка,
	               |	ДолжностиПредприятия.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.ДолжностиПредприятия КАК ДолжностиПредприятия
	               |ГДЕ
	               |	ДолжностиПредприятия.Отдел = &Отдел";
	Запрос.УстановитьПараметр("Отдел",Объект.Отдел);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.Должность.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.Должность.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура доступностьОтделов()
	Элементы.ЦФО.Доступность = ЗначениеЗаполнено(Объект.Город);
	Элементы.Отдел.Доступность = ЗначениеЗаполнено(Объект.ЦфО);
	Элементы.Должность.Доступность = ЗначениеЗаполнено(Объект.Отдел);
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	заполнениеСпискаЦФО();
	доступностьОтделов();
КонецПроцедуры

&НаКлиенте
Процедура ЦФОПриИзменении(Элемент)
	заполнениеСпискаОтделов();
	доступностьОтделов();
КонецПроцедуры

&НаКлиенте
Процедура ОтделПриИзменении(Элемент)
	заполнениеСпискаДолжностей();
	доступностьОтделов();
КонецПроцедуры


	

#Область СлужебныеПроцедурыИФункции


#КонецОбласти