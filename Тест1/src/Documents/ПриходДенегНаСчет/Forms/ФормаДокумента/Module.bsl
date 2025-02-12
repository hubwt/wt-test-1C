#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сум = 0;
	Для каждого стр из ТекущийОбъект.ТабличнаяЧасть1 Цикл
		сум = сум + стр.Сумма;
	КонецЦикла;
	ТекущийОбъект.ОбщаяСумма = сум;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОстаткиБалансИзменение");
	
	ЗакрытьФорму = Ложь;
	Если ПараметрыЗаписи.Свойство("ПровестиИЗакрыть", ЗакрытьФорму) Тогда
		Если ЗакрытьФорму = Истина Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды   
	
	ИспользоватьАвтосервис = ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис");
	ИспользоватьГрузоперевозки = ПолучитьФункциональнуюОпцию("дт_ИспользоватьГрузоперевозки");
	ИспользоватьРазборку = ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку");
	
	УправлениеФормой(ЭтаФорма);
	
	///+ГомзМА 28.06.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь() = Справочники.Пользователи.НайтиПоНаименованию("Вадяева Дарья Викторовна") Тогда
		Элементы.Менеджер.ТолькоПросмотр = Ложь;
	КонецЕсли;
	///-ГомзМА 28.03.2023
	
	///+ГомзМА 28.08.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 28.08.2023
	
	
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды    
	
	//Волков ИО 07.12.23 ++ 
	ЭтаФорма.Клиент = Объект.Контрагент;
	//Волков ИО 07.12.23 --
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЭтаФорма.Модифицированность
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
		И ЗначениеЗаполнено(Объект.Счет) 
		И НЕ ПараметрыЗаписи.Свойство("ОтключитьПроверкуСчета") Тогда
		
		ТекстСообщения = "";
		Если Не ПроверитьСоответствиеСчетов(ТекстСообщения) Тогда
			
			Отказ = Истина;
			Оповещение = Новый ОписаниеОповещения("ПередЗаписью_Продолжение", ЭтаФорма, ПараметрыЗаписи);
			ПоказатьВопрос(Оповещение, ТекстСообщения + "Продолжить?", РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ЗаказНаряд")
		ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ЗаказНаДоставку")
		ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
		
		Объект.Сделка = ВыбранноеЗначение;
		СделкаПриИзменении(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	Для каждого СтрокаТаблицы Из Объект.ТабличнаяЧасть1 Цикл
		
		СтрокаТаблицы.Счет = Объект.Счет;	
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ЗаполнитьПоСделке = УстановитьКонтрагентаПоВидуОперации();
	
	Если ЗаполнитьПоСделке Тогда
		ЗаполнитьПоСделкеСервер();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Функция УстановитьКонтрагентаПоВидуОперации()
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя") Тогда
		
		Если ТипЗнч(Объект.Контрагент) <> Тип("СправочникСсылка.Клиенты") Тогда
			Объект.Контрагент = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");
		КонецЕсли;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаКомитента") Тогда
		
		Если ТипЗнч(Объект.Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
			Объект.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		КонецЕсли;
	Иначе 
		
		Возврат Ложь;
		
	КонецЕсли;
	
	
	Возврат Истина;
	
КонецФункции // УстановитьКонтрагентаПоВидуОперации()


// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ЗаполнитьПоСделкеСервер()
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	ДокОбъект.Заполнить(Новый Структура("ВидОперации,Сделка", Объект.ВидОперации, Объект.Сделка));
	ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	
КонецПроцедуры // ЗаполнитьПоСделкеСервер()


Процедура СделканачалоВыбораСервер(ДанныеВыбора) 
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Клиент);
	
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//Волков ИО 07.12.23 ++
	//Если ЗначениеЗаполнено(Клиент) Тогда
	//	
	//	Отбор = Новый Структура();
	//	Отбор.Вставить("Клиент", Клиент);
	//	
	//	ПараметрыФормыВыбора = Новый Структура("Отбор,ТекущаяСтрока", Отбор, Объект.Сделка);
	//	
	//	СтандартнаяОбработка = Ложь;	
	//	ОткрытьФорму("Документ.ПродажаЗапчастей.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	//	
	//КонецЕсли;
	//Волков ИО 07.12.23 --
	
	//Если Не ЗначениеЗаполнено(Объект.Контрагент) ИЛИ (НЕ ИспользоватьГрузоперевозки И НЕ ИспользоватьАвтосервис) Тогда
	//	// для Разборки Контрагент не используется
	//	Возврат
	//КонецЕсли;
	//
	//Отбор = Новый Структура();
	//Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаКомитента") Тогда
	//	Отбор.Вставить("Комитент", Объект.Контрагент);
	//ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя") Тогда
	//	Отбор.Вставить("Клиент", Объект.Контрагент);
	//Иначе
	//	Возврат
	//КонецЕсли;
	//
	//ПараметрыФормыВыбора = Новый Структура("Отбор,ТекущаяСтрока", Отбор, Объект.Сделка);
	//
	//Если ИспользоватьАвтосервис Тогда
	//	
	//	СтандартнаяОбработка = Ложь;	
	//	ОткрытьФорму("Документ.ЗаказНаряд.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	//	
	//ИначеЕсли ИспользоватьГрузоперевозки Тогда
	//	
	//	СтандартнаяОбработка = Ложь;	
	//	ОткрытьФорму("Документ.ЗаказНаДоставку.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	//	
	//ИначеЕсли ИспользоватьРазборку Тогда
	//	
	//	СтандартнаяОбработка = Ложь;	
	//	ОткрытьФорму("Документ.ПродажаЗапчастей.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Сделка) Тогда
		СделкаПриИзмененииСервер();
	Иначе
		УстановитьКонтрагентаПоВидуОперации();
	КонецЕсли;
	
	//Волков ИО 06.12.23++ 
	
	ЭтотОбъект.Клиент = ОтборКлиента();
	//Волков ИО 06.12.23 -- 	
КонецПроцедуры

Функция ОтборКлиента()
	
	Запрос = Новый Запрос;
	запрос.Текст = 
	"ВЫБРАТЬ первые 1
	|	ПродажаЗапчастей.Клиент КАК Клиент
	|ИЗ
	|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	|ГДЕ
	|	ПродажаЗапчастей.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Сделка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();	
	
	Пока Выборка.Следующий() Цикл
		
		Клиент = Выборка.Клиент;
		
	КонецЦикла;
	
	Возврат Клиент;
	
	
КонецФункции 


&НаСервере
Процедура СделкаПриИзмененииСервер()
	
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаКомитента") Тогда
		Объект.Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сделка, "Комитент");
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя") Тогда
		Объект.Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сделка, "Клиент")
	КонецЕсли;
	
КонецПроцедуры // СделкаПриИзмененииСервер()


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

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	Записать(Новый Структура("РежимЗаписи,ПровестиИЗакрыть", РежимЗаписиДокумента.Проведение, Истина));
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервере
Функция ПроверитьСоответствиеСчетов(ТекстСообщения)
	
	Результат = Истина;
	
	
	Если ЗначениеЗаполнено(Объект.Сделка) 
		И ТипЗнч(Объект.Сделка) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
		
		ТипОплаты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Сделка, Новый Структура("Счет", "TipOplati.Счет"));
		СчетПродажи = ТипОплаты.Счет;
		Если ЗначениеЗаполнено(СчетПродажи)
			И ЗначениеЗаполнено(Объект.Счет) 
			И СчетПродажи <> Объект.Счет Тогда
			
			Результат = Ложь;
			ТекстСообщения = ТекстСообщения + СтрШаблон("Счет не соответствует типу оплаты, указанному в документе %1", Объект.Сделка) + Символы.ПС;
			
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции // ПроверитьСоответствиеСчетов()



&НаКлиенте
Процедура ПередЗаписью_Продолжение(РезультатВопроса, ПараметрыЗаписи = Неопределено) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	
	Если ПараметрыЗаписи = Неопределено Тогда
		ПараметрыЗаписи = Новый Структура();
	КонецЕсли;	
	
	ПараметрыЗаписи.Вставить("ОтключитьПроверкуСчета", Истина);
	
	Записать(ПараметрыЗаписи);
	
	ЗакрытьФорму = Ложь;
	Если ПараметрыЗаписи.Свойство("ПровестиИЗакрыть", ЗакрытьФорму) Тогда
		Если ЗакрытьФорму = Истина Тогда
			Попытка
				
				Закрыть();	
				
			Исключение
				
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

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
	
	ОплатаОтКонтрагента = Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.Прочее");
	//Волков++
	Элементы.ГруппаОплатаКонтрагента.Видимость = ОплатаОтКонтрагента;
	//Волков--
	Элементы.ТабличнаяЧасть1.Видимость = (Объект.ТабличнаяЧасть1.Количество() <> 0);
	
	Элементы.ФормаПровестиИЗакрыть.Доступность = Не Форма.ТолькоПросмотр;
	
	
КонецПроцедуры // УправлениеФормой()


&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	///+ГомзМА 28.08.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава")) ИЛИ
		ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_Зарплата")) Тогда 
		Элементы.Ответственный.Видимость = Истина;
	КонецЕсли;
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПомощникБухгалтера")) Тогда
		Элементы.Менеджер.ТолькоПросмотр = Истина;
	КонецЕсли;
	///-ГомзМА 28.08.2023
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Клиент) Тогда 
		
		Список = Новый СписокЗначений();

		Список.Добавить(Клиент);
		
		РезультатВыбора = ВыбратьИзСписка(Список, Клиент);
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	
	Объект.Контрагент = Клиент;
	
КонецПроцедуры


#КонецОбласти