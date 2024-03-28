
#Область ОбработчикиСобытийФормы


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОстаткиБалансИзменение");
КонецПроцедуры

&НаКлиенте
Процедура ОткудаПриИзменении(Элемент)
	
	УстановитьВалюту(Объект.Откуда, "ВалютаНачальная");
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КудаПриИзменении(Элемент)
	
	УстановитьВалюту(Объект.Куда, "ВалютаКонечная");
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеФормой(ЭтаФорма);
	
	///+ГомзМА 28.08.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 28.08.2023
	
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


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	ОбновитьКурс();
КонецПроцедуры

&НаКлиенте
Процедура СуммаКонечнаяПриИзменении(Элемент)
	ОбновитьКурс();
КонецПроцедуры

&НаКлиенте
Процедура КурсПриИзменении(Элемент)
	
	Если Объект.Курс = 0 Тогда
		Возврат
	КонецЕсли;
	
	Руб = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если Объект.ВалютаНачальная = Руб Тогда
		
		Объект.СуммаКонечная = Объект.Сумма / Объект.Курс;
		
	ИначеЕсли Объект.ВалютаКонечная = Руб Тогда
		
		Объект.Сумма = Объект.СуммаКонечная / Объект.Курс;
		
	Иначе // обе валюты - не рубли
		
		Объект.СуммаКонечная = Объект.Сумма / Объект.Курс;
		
	КонецЕсли;
КонецПроцедуры





#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



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

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура УстановитьВалюту(Счет, ИмяПоляВалюта)

	Объект[ИмяПоляВалюта] = ?(ЗначениеЗаполнено(Счет), 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Счет, "Валюта"),
		Неопределено
	);

КонецПроцедуры // УстановитьВалюту()



// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ЭтоКонвертацияВалюты = ЗначениеЗаполнено(Объект.ВалютаНачальная)
		И ЗначениеЗаполнено(Объект.ВалютаКонечная)
		И Объект.ВалютаНачальная <> Объект.ВалютаКонечная;
		
	
    Элементы.ГруппаКонвертацияВалюты.Видимость = ЭтоКонвертацияВалюты;
	
	
КонецПроцедуры // УправлениеФормой()



&НаКлиенте
Процедура ОбновитьКурс()

	Если Объект.Сумма <> 0 
		И Объект.СуммаКонечная <> 0 Тогда
		
		Если Объект.Сумма > Объект.СуммаКонечная Тогда
			Объект.Курс = Объект.Сумма / Объект.СуммаКонечная;
		Иначе	
			Объект.Курс = Объект.СуммаКонечная / Объект.Сумма;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ОбновитьКурс()


&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()

	///+ГомзМА 28.08.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава")) ИЛИ
		 ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_Зарплата")) Тогда 
	Элементы.Ответственный.Видимость = Истина;
	КонецЕсли;
	///-ГомзМА 28.08.2023

КонецПроцедуры



#КонецОбласти