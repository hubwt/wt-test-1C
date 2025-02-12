

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Свойство("НомерСтроки") Тогда
		Элементы.Товары.ТекущаяСтрока = Параметры.НомерСтроки - 1;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборСтроки") Тогда
		
		СтрокиТаблицы = Объект.Товары.НайтиСтроки(Параметры.ОтборСтроки);
		Если СтрокиТаблицы.Количество() <> 0 Тогда
			Элементы.Товары.ТекущаяСтрока = СтрокиТаблицы[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьФункциональныеОпции();
	
	ОбновитьРасчетныеПоказатели();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьРасчетныеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	// Вставить содержимое обработчика.
	Перем Команда;
	Перем деталь;
	Перем код;

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ВыбранноеЗначение.Свойство("Команда", Команда);
        Если Команда = "ПравильныйПоиск"   Тогда
           ВыбранноеЗначение.Свойство("Код", код);
		   ВыбранноеЗначение.Свойство("деталь", деталь);
		   ДобавлениеЗапчасти(код,деталь);
	   КонецЕсли
   КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладОтправительПриИзменении(Элемент)
	
	СкладПриИзмененииНаСервере(Элемент.Имя, "Ответственный");
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПолучательПриИзменении(Элемент)
	
	СкладПриИзмененииНаСервере(Элемент.Имя, "Проверяющий");
	
	ОбновитьФункциональныеОпции();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Процедура СкладПриИзмененииНаСервере(ИмяРеквизитаСклад, ИмяРеквизитаОтветственный)
	
	Склад = Объект[ИмяРеквизитаСклад];
	
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Возврат
	КонецЕсли;
	
	Объект[ИмяРеквизитаОтветственный] = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "Ответственный");

	Если ИмяРеквизитаСклад = "СкладОтправитель" Тогда
		ОбновитьМестаХранения();
	КонецЕсли;

КонецПроцедуры // СкладПриИзмененииНаСервере()



&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОбновитьМестаХранения();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Товары

&НаКлиенте
Процедура ТоварыТоварПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	СвойстваСтроки = Новый Структура();
	СвойстваСтроки.Вставить("Дата", Объект.Дата);
	СвойстваСтроки.Вставить("Склад", Объект.СкладОтправитель);
	СвойстваСтроки.Вставить("Номенклатура", ТекСтрока.Товар);
	
	ТаблицаТоварПриИзмененииСервер(СвойстваСтроки);
	
	ЗаполнитьЗначенияСвойств(ТекСтрока, СвойстваСтроки, "МестоХранения");
	
КонецПроцедуры

&НаСервере
Процедура ТаблицаТоварПриИзмененииСервер(ДанныеЗаполнения)
	ДанныеЗаполнения.Вставить("МестоХранения", дт_АдресноеХранение.ПолучитьМестоХранения(ДанныеЗаполнения));	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьОбщЦену();
КонецПроцедуры


&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьОбщЦену();
КонецПроцедуры


&НаКлиенте
Процедура ТоварыОбщЦенаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьОбщЦену();
КонецПроцедуры



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
Процедура Добавить(Команда)
	// Вставить содержимое обработчика.
	Форма = ПолучитьФорму("Обработка.ВыборНоменклатуры.Форма");
	Форма.ВладелецФормы = ЭтаФорма;       
	Форма.Открыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьРасчетныеПоказатели()
	
	ОбновитьместаХранения();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьМестаХранения() Экспорт
	
	дт_АдресноеХранение.ЗаполнитьМестаХранения(ЭтаФорма, "СкладОтправитель", "Товары", "Товар");
	
КонецПроцедуры



&НаСервере
Процедура  ДобавлениеЗапчасти(код,деталь)
	Товар = Справочники.Номенклатура.НайтиПоКоду(код);
	Строка = Объект.Таблица.Добавить();
	Строка.Товар = Товар;
	Строка.Цена = деталь.Цена;
	Строка.Количество = 0;
КонецПроцедуры



&НаСервере
Процедура ОбновитьОбщЦену()
	Объект.Итого = 0;
	Для Каждого ТекСтрокаТаблица Из Объект.Товары Цикл
		ТекСтрокаТаблица.ОбщЦена =  ТекСтрокаТаблица.Цена * ТекСтрокаТаблица.Количество;
		Объект.Итого = Объект.Итого + ТекСтрокаТаблица.ОбщЦена;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьМакет(название)
	Возврат  Документы.ПеремещениеТоваров.ПолучитьМакет(название);
КонецФункции





&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ДоступныеСтатусы = Элементы.Статус.СписокВыбора;
	ДоступныеСтатусы.Очистить();
	ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПеремещений.ВРаботе"));
	ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПеремещений.Отправлен"));
	ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПеремещений.КОтправке"));
	
	
	СтатусПринят = ПредопределенноеЗначение("Перечисление.СтатусыПеремещений.Принят");
	Если Форма.ЕстьПравоПриемки 
		ИЛИ Объект.Статус = СтатусПринят Тогда
		
		ДоступныеСтатусы.Добавить(СтатусПринят);
		
	КонецЕсли;
	
	//Элементы.Статус.СписокВыбора = ДоступныеСтатусы;

КонецПроцедуры // УправлениеФормой()

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ОбновитьФункциональныеОпции()

	ЕстьПравоПриемки = Пользователи.ЭтоПолноправныйПользователь()
		ИЛИ РольДоступна("дт_ПриемкаПеремещений");
	
	Если НЕ ЕстьПравоПриемки 
		И ЗначениеЗаполнено(Объект.СкладПолучатель) Тогда
		Ответственный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СкладПолучатель, "Ответственный");
		
		Если ЗначениеЗаполнено(Ответственный) Тогда
			ЕстьПравоПриемки = Пользователи.ТекущийПользователь() = Ответственный;
		КонецЕсли;
	КонецЕсли;
		
КонецФункции // ЕстьПравоПриемки()

#КонецОбласти





