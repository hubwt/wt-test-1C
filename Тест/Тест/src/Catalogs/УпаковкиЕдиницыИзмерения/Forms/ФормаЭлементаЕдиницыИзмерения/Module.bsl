
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	ПриЧтенииСозданииНаСервере()
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РазрешенаСменаРодителя");

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбновитьЗаголовокФормы();
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЕдиницыИзмеренияПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.Форма.РазблокированиеРеквизитовЕдиницыИзмерения",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	НастроитьФорму();
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	Если Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Длина
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Площадь
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Энергия
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.ЭлектрическийЗаряд
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Мощность
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Время Тогда
		Элементы.ГруппаКратность.Видимость = Истина;
		ЗаголовокДекорации = НСтр("ru = '%ЕдиницаИзмерения% =';
									|en = '%ЕдиницаИзмерения% ='");
		Элементы.Декорация1.Заголовок = СтрЗаменить(ЗаголовокДекорации, "%ЕдиницаИзмерения%", Объект.Наименование);
	Иначе 
		Элементы.ГруппаКратность.Видимость = Ложь;
		Объект.Числитель = 0;
		Объект.Знаменатель = 0;		
	КонецЕсли;
	
	Если Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Длина Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м';
													|en = 'm'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Площадь Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м2';
													|en = 'm2'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м3';
													|en = 'm3'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'кг';
													|en = 'kg'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Энергия Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ватт-час';
													|en = 'watt-hour'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Мощность Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ватт';
													|en = 'watt'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.ЭлектрическийЗаряд Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ампер-час';
													|en = 'ampere-hour'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Время Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'с';
													|en = 'sec'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	ПредставлениеТипа = НСтр("ru = 'Единица измерения';
							|en = 'Unit'");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (создание)';
				|en = '%1 (Create)'"),
			ПредставлениеТипа);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2)';
				|en = '%1 (%2)'"),
			Объект.Наименование,
			ПредставлениеТипа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти




