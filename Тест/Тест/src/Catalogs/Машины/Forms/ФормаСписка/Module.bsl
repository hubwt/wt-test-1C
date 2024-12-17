
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис")
		ИЛИ ПолучитьФункциональнуюОпцию("дт_ИспользоватьГрузоперевозки") Тогда
		
		ЭтаФорма.Заголовок = "Автомобили";
		ЭтаФорма.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	ЕстьДоступКПоказателям = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПоказателиАвтомобилей) И ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку");
	ЕстьГрузоперевозки = ПолучитьФункциональнуюОпцию("дт_ИспользоватьГрузоперевозки")
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТопливоВБаках);
		
	// Если нет прав на регистр сведений ПоказателиАвтомобилей, то из запроса исключим соединение
	Если НЕ ЕстьДоступКПоказателям Тогда
		
		ТекстЗапроса = Список.ТекстЗапроса;
		
		Индекс = СтрНайти(ТекстЗапроса, "ПоказателиАвтомобилей");
		Если Индекс <> 0 Тогда
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, 
				"ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели",
				""
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)",
				""
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0)",
				"0"
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0)",
				"0"
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ВТ_Показатели.Прибыль, 0)",
				"0"
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная",
				"0"
			);
			
			Список.ТекстЗапроса = ТекстЗапроса;
			
		КонецЕсли;
			
	КонецЕсли;
	
	Если НЕ ЕстьГрузоперевозки Тогда
		ТекстЗапроса = Список.ТекстЗапроса;
		
		Индекс = СтрНайти(ТекстЗапроса, "ТопливоВБакахОстатки");
		Если Индекс <> 0 Тогда
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, 
				"ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки",
				""
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ПО ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка",
				""
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0)",
				"0"
			);
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0)",
				"0"
			);
			
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.ГруппаПоказатели.Видимость = ЕстьДоступКПоказателям;
	Элементы.ГруппаГрузоперевозки.Видимость = ЕстьГрузоперевозки;
	
	УстановитьУсловноеОформление();
	
	СортировкаМашинаАгрегат = 3;
	
	// Комлев АА 17/12/24  +++
	ДатаГодНазад = ДобавитьМесяц(ТекущаяДатаСеанса(), -12);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", ДатаГодНазад);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ТекущаяДатаСеанса());
	// Комлев АА 17/12/24  ---
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы



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
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Прибыль, Рентабельность - выделять отрицательные
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Прибыль");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Рентабельность");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Сумма", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
	

КонецПроцедуры // УстановитьУсловноеОформление()

#КонецОбласти

&НаКлиенте
Процедура ОтчётПоЗапчастям(Команда)
		
	ИмяОтчета = "ОстаткиЗапчастейПоАвтомобилям";
	
	ПараметрыОткрытия = ПолучитьПараметрыОткрытияОтчета(ИмяОтчета, элементы.Список.ТекущиеДанные.ссылка,"Машина");
	ОткрытьФорму("Отчет." + ИмяОтчета + ".ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
КонецПроцедуры



&НаКлиенте
Процедура ОтчётПоПроданнымЗапчастям(Команда)
	
	ИмяОтчета = "ПродажаЗапчастейПоАвтомобилям";
	
	ПараметрыОткрытия = ПолучитьПараметрыОткрытияОтчета(ИмяОтчета, элементы.Список.ТекущиеДанные.ссылка,"Автомобиль");
	ОткрытьФорму("Отчет." + ИмяОтчета + ".ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
КонецПроцедуры


&НаСервереБезКонтекста
Процедура УстановитьЭлементПользовательскогоОтбораСКД(КомпоновщикНастроек, ВидСравнения, ИмяПоля, Значение)
	
	ЭлементОтбора =  КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	//ЭлементОтбораПользовательский =  ПользовательскийОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор();
	ЭлементОтбора.ВидСравнения = ВидСравнения;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементОтбора.ПравоеЗначение = Значение;
	ЭлементОтбора.Использование = Истина;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьПараметрыОткрытияОтчета(ИмяОтчета, Авто,ЭлементОтбора)
	
	ОтчетОбъект = Отчеты[ИмяОтчета].Создать();
	
	КомпоновщикНастроек = ОтчетОбъект.КомпоновщикНастроек;
	
	УстановитьЭлементПользовательскогоОтбораСКД(КомпоновщикНастроек, ВидСравненияКомпоновкиДанных.Равно, 
	ЭлементОтбора, Авто);
	
	ПараметрыОткрытия = Новый Структура(); 	
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОткрытия.Вставить("Вариант", КомпоновщикНастроек.Настройки);
	ПараметрыОткрытия.Вставить("ПользовательскиеНастройки", КомпоновщикНастроек.ПользовательскиеНастройки);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаСервере
Процедура СортировкаМашинаАгрегатПриИзмененииНаСервере()
	
	///+ГомзМА 29.09.2023
	Если СортировкаМашинаАгрегат = 1 Тогда
		Текст = "ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейВсего
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	РегистрНакопления1.Регистратор ССЫЛКА Документ.ПоступлениеЗапчастей
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПродаж
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	(РегистрНакопления1.Регистратор ССЫЛКА Документ.ПродажаЗапчастей
		|	ИЛИ РегистрНакопления1.Регистратор ССЫЛКА Документ.ЗаказНаряд)
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1Остатки.машина КАК машина,
		|	СУММА(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПоМашинам
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|ГДЕ
		|	РегистрНакопления1Остатки.КолвоОстаток > 0
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1Остатки.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникМашины.Ссылка КАК Ссылка,
		|	СправочникМашины.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникМашины.Код КАК Код,
		|	СправочникМашины.Наименование КАК Наименование,
		|	СправочникМашины.ВинКод КАК ВинКод,
		|	СправочникМашины.Комментарий КАК Комментарий,
		|	СправочникМашины.Сумма КАК Сумма,
		|	СправочникМашины.Производитель КАК Производитель,
		|	СправочникМашины.Год КАК Год,
		|	СправочникМашины.НПорядок КАК НПорядок,
		|	СправочникМашины.ТипТС КАК ТипТС,
		|	СправочникМашины.МаркаТС КАК МаркаТС,
		|	СправочникМашины.Дата КАК Дата,
		|	СправочникМашины.КодМашины КАК КодМашины,
		|	СправочникМашины.ГосНомер КАК ГосНомер,
		|	СправочникМашины.Водитель КАК Водитель,
		|	СправочникМашины.ПоказаниеОдометраНаНачалоЭксплуатации КАК ПоказаниеОдометраНаНачалоЭксплуатации,
		|	СправочникМашины.ЭтоПрицеп КАК ЭтоПрицеп,
		|	ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0) КАК Рентабельность,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0) КАК ВыручкаОплаченная,
		|	ЕСТЬNULL(ВТ_Показатели.Прибыль, 0) КАК Прибыль,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0) КАК ТопливоКоличество,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0) КАК ТопливоСтоимость,
		|	СправочникМашины.ТипМашины КАК ТипМашины,
		|	СправочникМашины.Поставщик КАК Поставщик,
		|	СправочникМашины.МашинаАгрегат КАК МашинаАгрегат,
		|	ВТ_КоличествоДеталейПоМашинам.КолвоОстаток КАК КоличествоДеталейОстаток,
		|	ВТ_КоличествоДеталейВсего.Колво КАК КоличествоДеталейВсего,
		|	ВТ_КоличествоДеталейПродаж.Колво КАК КоличествоПроданныхДеталей,
		|	СправочникМашины.Серия КАК Серия,
		|	СправочникМашины.Модель КАК Модель,
		|	СправочникМашины.СрокОкупаемостиВМесяцах КАК СрокОкупаемостиВМесяцах,
		|	СправочникМашины.ВысотаКабины,
		|	СправочникМашины.ДлинаКабины,
		|	СправочникМашины.ШиринаПереднейСекцииШасси
		|ИЗ
		|	Справочник.Машины КАК СправочникМашины
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели
		|		ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки
		|		ПО (ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПоМашинам КАК ВТ_КоличествоДеталейПоМашинам
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПоМашинам.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейВсего КАК ВТ_КоличествоДеталейВсего
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейВсего.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПродаж КАК ВТ_КоличествоДеталейПродаж
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПродаж.машина
		|ГДЕ
		|	СправочникМашины.МашинаАгрегат = 1";

		
		Список.ТекстЗапроса = Текст;
		
	ИначеЕсли СортировкаМашинаАгрегат = 2 Тогда
				Текст = "ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейВсего
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	РегистрНакопления1.Регистратор ССЫЛКА Документ.ПоступлениеЗапчастей
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПродаж
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	(РегистрНакопления1.Регистратор ССЫЛКА Документ.ПродажаЗапчастей
		|	ИЛИ РегистрНакопления1.Регистратор ССЫЛКА Документ.ЗаказНаряд)
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1Остатки.машина КАК машина,
		|	СУММА(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПоМашинам
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|ГДЕ
		|	РегистрНакопления1Остатки.КолвоОстаток > 0
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1Остатки.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникМашины.Ссылка КАК Ссылка,
		|	СправочникМашины.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникМашины.Код КАК Код,
		|	СправочникМашины.Наименование КАК Наименование,
		|	СправочникМашины.ВинКод КАК ВинКод,
		|	СправочникМашины.Комментарий КАК Комментарий,
		|	СправочникМашины.Сумма КАК Сумма,
		|	СправочникМашины.Производитель КАК Производитель,
		|	СправочникМашины.Год КАК Год,
		|	СправочникМашины.НПорядок КАК НПорядок,
		|	СправочникМашины.ТипТС КАК ТипТС,
		|	СправочникМашины.МаркаТС КАК МаркаТС,
		|	СправочникМашины.Дата КАК Дата,
		|	СправочникМашины.КодМашины КАК КодМашины,
		|	СправочникМашины.ГосНомер КАК ГосНомер,
		|	СправочникМашины.Водитель КАК Водитель,
		|	СправочникМашины.ПоказаниеОдометраНаНачалоЭксплуатации КАК ПоказаниеОдометраНаНачалоЭксплуатации,
		|	СправочникМашины.ЭтоПрицеп КАК ЭтоПрицеп,
		|	ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0) КАК Рентабельность,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0) КАК ВыручкаОплаченная,
		|	ЕСТЬNULL(ВТ_Показатели.Прибыль, 0) КАК Прибыль,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0) КАК ТопливоКоличество,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0) КАК ТопливоСтоимость,
		|	СправочникМашины.ТипМашины КАК ТипМашины,
		|	СправочникМашины.Поставщик КАК Поставщик,
		|	СправочникМашины.МашинаАгрегат КАК МашинаАгрегат,
		|	ВТ_КоличествоДеталейПоМашинам.КолвоОстаток КАК КоличествоДеталейОстаток,
		|	ВТ_КоличествоДеталейВсего.Колво КАК КоличествоДеталейВсего,
		|	ВТ_КоличествоДеталейПродаж.Колво КАК КоличествоПроданныхДеталей,
		|	СправочникМашины.Серия КАК Серия,
		|	СправочникМашины.Модель КАК Модель,
		|	СправочникМашины.СрокОкупаемостиВМесяцах КАК СрокОкупаемостиВМесяцах,
		|	СправочникМашины.ВысотаКабины,
		|	СправочникМашины.ДлинаКабины,
		|	СправочникМашины.ШиринаПереднейСекцииШасси
		|ИЗ
		|	Справочник.Машины КАК СправочникМашины
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели
		|		ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки
		|		ПО (ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПоМашинам КАК ВТ_КоличествоДеталейПоМашинам
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПоМашинам.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейВсего КАК ВТ_КоличествоДеталейВсего
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейВсего.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПродаж КАК ВТ_КоличествоДеталейПродаж
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПродаж.машина
		|ГДЕ
		|	СправочникМашины.МашинаАгрегат = 2";
		
		
		Список.ТекстЗапроса = Текст;
		
	ИначеЕсли СортировкаМашинаАгрегат = 3 Тогда
			Текст = "ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейВсего
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	РегистрНакопления1.Регистратор ССЫЛКА Документ.ПоступлениеЗапчастей
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1.машина КАК машина,
		|	СУММА(РегистрНакопления1.Колво) КАК Колво
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПродаж
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
		|ГДЕ
		|	(РегистрНакопления1.Регистратор ССЫЛКА Документ.ПродажаЗапчастей
		|	ИЛИ РегистрНакопления1.Регистратор ССЫЛКА Документ.ЗаказНаряд)
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрНакопления1Остатки.машина КАК машина,
		|	СУММА(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток
		|ПОМЕСТИТЬ ВТ_КоличествоДеталейПоМашинам
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|ГДЕ
		|	РегистрНакопления1Остатки.КолвоОстаток > 0
		|СГРУППИРОВАТЬ ПО
		|	РегистрНакопления1Остатки.машина
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникМашины.Ссылка КАК Ссылка,
		|	СправочникМашины.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникМашины.Код КАК Код,
		|	СправочникМашины.Наименование КАК Наименование,
		|	СправочникМашины.ВинКод КАК ВинКод,
		|	СправочникМашины.Комментарий КАК Комментарий,
		|	СправочникМашины.Сумма КАК Сумма,
		|	СправочникМашины.Производитель КАК Производитель,
		|	СправочникМашины.Год КАК Год,
		|	СправочникМашины.НПорядок КАК НПорядок,
		|	СправочникМашины.ТипТС КАК ТипТС,
		|	СправочникМашины.МаркаТС КАК МаркаТС,
		|	СправочникМашины.Дата КАК Дата,
		|	СправочникМашины.КодМашины КАК КодМашины,
		|	СправочникМашины.ГосНомер КАК ГосНомер,
		|	СправочникМашины.Водитель КАК Водитель,
		|	СправочникМашины.ПоказаниеОдометраНаНачалоЭксплуатации КАК ПоказаниеОдометраНаНачалоЭксплуатации,
		|	СправочникМашины.ЭтоПрицеп КАК ЭтоПрицеп,
		|	ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0) КАК Рентабельность,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0) КАК ВыручкаОплаченная,
		|	ЕСТЬNULL(ВТ_Показатели.Прибыль, 0) КАК Прибыль,
		|	ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0) КАК ТопливоКоличество,
		|	ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0) КАК ТопливоСтоимость,
		|	СправочникМашины.ТипМашины КАК ТипМашины,
		|	СправочникМашины.Поставщик КАК Поставщик,
		|	СправочникМашины.МашинаАгрегат КАК МашинаАгрегат,
		|	ВТ_КоличествоДеталейПоМашинам.КолвоОстаток КАК КоличествоДеталейОстаток,
		|	ВТ_КоличествоДеталейВсего.Колво КАК КоличествоДеталейВсего,
		|	ВТ_КоличествоДеталейПродаж.Колво КАК КоличествоПроданныхДеталей,
		|	СправочникМашины.Серия КАК Серия,
		|	СправочникМашины.Модель КАК Модель,
		|	СправочникМашины.СрокОкупаемостиВМесяцах КАК СрокОкупаемостиВМесяцах,
		|	СправочникМашины.ВысотаКабины,
		|	СправочникМашины.ДлинаКабины,
		|	СправочникМашины.ШиринаПереднейСекцииШасси
		|ИЗ
		|	Справочник.Машины КАК СправочникМашины
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели
		|		ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки
		|		ПО (ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПоМашинам КАК ВТ_КоличествоДеталейПоМашинам
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПоМашинам.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейВсего КАК ВТ_КоличествоДеталейВсего
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейВсего.машина
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПродаж КАК ВТ_КоличествоДеталейПродаж
		|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПродаж.машина";
		
		Список.ТекстЗапроса = Текст;
	КонецЕсли;
	///-ГомзМА 29.09.2023
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаМашинаАгрегатПриИзменении(Элемент)
	СортировкаМашинаАгрегатПриИзмененииНаСервере();
КонецПроцедуры







&НаКлиенте
Процедура ПоискОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПоискОкончаниеВводаТекстаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПоискОкончаниеВводаТекстаНаСервере()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПоискАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ПоискАвтоПодборНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПоискАвтоПодборНаСервере()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура Поиск(Команда)
	ПоискНаСервере1();
КонецПроцедуры

&НаСервере
Процедура ПоискНаСервере1()
	#Область БезПоиска
		ТекстЗапросаБезПоиска = "ВЫБРАТЬ
					|	РегистрНакопления1.машина КАК машина,
					|	СУММА(РегистрНакопления1.Колво) КАК Колво
					|ПОМЕСТИТЬ ВТ_КоличествоДеталейВсего
					|ИЗ
					|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
					|ГДЕ
					|	РегистрНакопления1.Регистратор ССЫЛКА Документ.ПоступлениеЗапчастей
					|
					|СГРУППИРОВАТЬ ПО
					|	РегистрНакопления1.машина
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	РегистрНакопления1.машина КАК машина,
					|	СУММА(РегистрНакопления1.Колво) КАК Колво
					|ПОМЕСТИТЬ ВТ_КоличествоДеталейПродаж
					|ИЗ
					|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
					|ГДЕ
					|	(РегистрНакопления1.Регистратор ССЫЛКА Документ.ПродажаЗапчастей
					|			ИЛИ РегистрНакопления1.Регистратор ССЫЛКА Документ.ЗаказНаряд)
					|
					|СГРУППИРОВАТЬ ПО
					|	РегистрНакопления1.машина
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	РегистрНакопления1Остатки.машина КАК машина,
					|	СУММА(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток
					|ПОМЕСТИТЬ ВТ_КоличествоДеталейПоМашинам
					|ИЗ
					|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
					|ГДЕ
					|	РегистрНакопления1Остатки.КолвоОстаток > 0
					|
					|СГРУППИРОВАТЬ ПО
					|	РегистрНакопления1Остатки.машина
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	СправочникМашины.Ссылка КАК Ссылка,
					|	СправочникМашины.ДлинаКабины КАК ДлинаКабины,
					|	СправочникМашины.ВысотаКабины КАК ВысотаКабины,
					|	СправочникМашины.ШиринаПереднейСекцииШасси КАК ШиринаПереднейСекцииШасси,
					|	СправочникМашины.ПометкаУдаления КАК ПометкаУдаления,
					|	СправочникМашины.Код КАК Код,
					|	СправочникМашины.Наименование КАК Наименование,
					|	СправочникМашины.ВинКод КАК ВинКод,
					|	СправочникМашины.Комментарий КАК Комментарий,
					|	СправочникМашины.Сумма КАК Сумма,
					|	СправочникМашины.Производитель КАК Производитель,
					|	СправочникМашины.Год КАК Год,
					|	СправочникМашины.НПорядок КАК НПорядок,
					|	СправочникМашины.ТипТС КАК ТипТС,
					|	СправочникМашины.МаркаТС КАК МаркаТС,
					|	СправочникМашины.Дата КАК Дата,
					|	СправочникМашины.КодМашины КАК КодМашины,
					|	СправочникМашины.ГосНомер КАК ГосНомер,
					|	СправочникМашины.Водитель КАК Водитель,
					|	СправочникМашины.ПоказаниеОдометраНаНачалоЭксплуатации КАК ПоказаниеОдометраНаНачалоЭксплуатации,
					|	СправочникМашины.ЭтоПрицеп КАК ЭтоПрицеп,
					|	ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0) КАК Рентабельность,
					|	ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0) КАК ВыручкаОплаченная,
					|	ЕСТЬNULL(ВТ_Показатели.Прибыль, 0) КАК Прибыль,
					|	ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная,
					|	ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0) КАК ТопливоКоличество,
					|	ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0) КАК ТопливоСтоимость,
					|	СправочникМашины.ТипМашины КАК ТипМашины,
					|	СправочникМашины.Поставщик КАК Поставщик,
					|	СправочникМашины.МашинаАгрегат КАК МашинаАгрегат,
					|	ВТ_КоличествоДеталейПоМашинам.КолвоОстаток КАК КоличествоДеталейОстаток,
					|	ВТ_КоличествоДеталейВсего.Колво КАК КоличествоДеталейВсего,
					|	ВТ_КоличествоДеталейПродаж.Колво КАК КоличествоПроданныхДеталей,
					|	СправочникМашины.Серия КАК Серия,
					|	СправочникМашины.Модель КАК Модель,
					|	СправочникМашины.СрокОкупаемостиВМесяцах КАК СрокОкупаемостиВМесяцах
					|ИЗ
					|	Справочник.Машины КАК СправочникМашины
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели
					|		ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки
					|		ПО (ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПоМашинам КАК ВТ_КоличествоДеталейПоМашинам
					|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПоМашинам.машина
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейВсего КАК ВТ_КоличествоДеталейВсего
					|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейВсего.машина
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПродаж КАК ВТ_КоличествоДеталейПродаж
					|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПродаж.машина";
					
	#КонецОбласти
	
	
	
	ТекстЗапросаСпоиском = "ВЫБРАТЬ
	|	РегистрНакопления1.машина КАК машина,
	|	СУММА(РегистрНакопления1.Колво) КАК Колво
	|ПОМЕСТИТЬ ВТ_КоличествоДеталейВсего
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
	|ГДЕ
	|	РегистрНакопления1.Регистратор ССЫЛКА Документ.ПоступлениеЗапчастей
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1.машина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1.машина КАК машина,
	|	СУММА(РегистрНакопления1.Колво) КАК Колво
	|ПОМЕСТИТЬ ВТ_КоличествоДеталейПродаж
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1
	|ГДЕ
	|	(РегистрНакопления1.Регистратор ССЫЛКА Документ.ПродажаЗапчастей
	|	ИЛИ РегистрНакопления1.Регистратор ССЫЛКА Документ.ЗаказНаряд)
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1.машина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникМашины.ДлинаКабины КАК ДлинаКабины,
	|	СправочникМашины.ВысотаКабины КАК ВысотаКабины,
	|	СправочникМашины.ШиринаПереднейСекцииШасси КАК ШиринаПереднейСекцииШасси,
	|	СправочникМашины.ПометкаУдаления КАК ПометкаУдаления,
	|	СправочникМашины.Сумма КАК Сумма,
	|	СправочникМашины.Производитель КАК Производитель,
	|	СправочникМашины.Год КАК Год,
	|	СправочникМашины.НПорядок КАК НПорядок,
	|	СправочникМашины.ТипТС КАК ТипТС,
	|	СправочникМашины.МаркаТС КАК МаркаТС,
	|	СправочникМашины.Дата КАК Дата,
	|	СправочникМашины.ПоказаниеОдометраНаНачалоЭксплуатации КАК ПоказаниеОдометраНаНачалоЭксплуатации,
	|	СправочникМашины.ЭтоПрицеп КАК ЭтоПрицеп,
	|	СправочникМашины.ТипМашины КАК ТипМашины,
	|	СправочникМашины.МашинаАгрегат КАК МашинаАгрегат,
	|	СправочникМашины.СрокОкупаемостиВМесяцах КАК СрокОкупаемостиВМесяцах
	|ПОМЕСТИТЬ ВТ_ЧисловыеПоля
	|ИЗ
	|	Справочник.Машины КАК СправочникМашины
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1Остатки.машина КАК машина,
	|	СУММА(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток
	|ПОМЕСТИТЬ ВТ_КоличествоДеталейПоМашинам
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.машина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникМашины.Ссылка КАК Ссылка,
	|	СправочникМашины.Код КАК Код,
	|	СправочникМашины.Наименование КАК Наименование,
	|	СправочникМашины.ВинКод КАК ВинКод,
	|	СправочникМашины.Комментарий КАК Комментарий,
	|	СправочникМашины.КодМашины КАК КодМашины,
	|	СправочникМашины.ГосНомер КАК ГосНомер,
	|	СправочникМашины.Водитель КАК Водитель,
	|	ЕСТЬNULL(ВТ_Показатели.Рентабельность, 0) КАК Рентабельность,
	|	ЕСТЬNULL(ВТ_Показатели.ВыручкаОплаченная, 0) КАК ВыручкаОплаченная,
	|	ЕСТЬNULL(ВТ_Показатели.Прибыль, 0) КАК Прибыль,
	|	ЕСТЬNULL(ВТ_Показатели.ВыручкаПотенциальная, 0) КАК ВыручкаПотенциальная,
	|	ЕСТЬNULL(ТопливоВБакахОстатки.КоличествоОстаток, 0) КАК ТопливоКоличество,
	|	ЕСТЬNULL(ТопливоВБакахОстатки.СтоимостьОстаток, 0) КАК ТопливоСтоимость,
	|	СправочникМашины.Поставщик КАК Поставщик,
	|	ВТ_КоличествоДеталейПоМашинам.КолвоОстаток КАК КоличествоДеталейОстаток,
	|	ВТ_КоличествоДеталейВсего.Колво КАК КоличествоДеталейВсего,
	|	ВТ_КоличествоДеталейПродаж.Колво КАК КоличествоПроданныхДеталей,
	|	СправочникМашины.Серия КАК Серия,
	|	СправочникМашины.Модель КАК Модель,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ДлинаКабины) КАК ДлинаКабины,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ВысотаКабины) КАК ВысотаКабины,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ШиринаПереднейСекцииШасси) КАК ШиринаПереднейСекцииШасси,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ПометкаУдаления) КАК ПометкаУдаления,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.Сумма) КАК Сумма,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.Производитель) КАК Производитель,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.Год) КАК Год,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.НПорядок) КАК НПорядок,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ТипТС) КАК ТипТС,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.МаркаТС) КАК МаркаТС,
	|	ВТ_ЧисловыеПоля.Дата КАК Дата,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ПоказаниеОдометраНаНачалоЭксплуатации) КАК ПоказаниеОдометраНаНачалоЭксплуатации,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ЭтоПрицеп) КАК ЭтоПрицеп,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.ТипМашины) КАК ТипМашины,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.МашинаАгрегат) КАК МашинаАгрегат,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_ЧисловыеПоля.СрокОкупаемостиВМесяцах) КАК СрокОкупаемостиВМесяцах
	|ИЗ
	|	Справочник.Машины КАК СправочникМашины
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПоказателиАвтомобилей КАК ВТ_Показатели
	|		ПО (ВТ_Показатели.Автомобиль = СправочникМашины.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТопливоВБаках.Остатки КАК ТопливоВБакахОстатки
	|		ПО (ТопливоВБакахОстатки.Автомобиль = СправочникМашины.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПоМашинам КАК ВТ_КоличествоДеталейПоМашинам
	|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПоМашинам.машина
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейВсего КАК ВТ_КоличествоДеталейВсего
	|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейВсего.машина
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоДеталейПродаж КАК ВТ_КоличествоДеталейПродаж
	|		ПО СправочникМашины.Ссылка = ВТ_КоличествоДеталейПродаж.машина,
	|	ВТ_ЧисловыеПоля КАК ВТ_ЧисловыеПоля
	|ГДЕ
	|	СправочникМашины.Код ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.Наименование ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.ВинКод ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.Комментарий ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.КодМашины ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.ГосНомер ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.Водитель.Наименование ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.Поставщик.Наименование ПОДОБНО &ТекстПоиска
	|	ИЛИ СправочникМашины.Модель.Наименование ПОДОБНО &ТекстПоиска";
		
			
					
	 Если Поиск <> "" Тогда
			Список.ТекстЗапроса = ТекстЗапросаСпоиском;
			Список.Параметры.УстановитьЗначениеПараметра("ТекстПоиска",  "%" + Поиск + "%" );
	Иначе Список.ТекстЗапроса  = ТекстЗапросаБезПоиска;
	КонецЕсли;
					 
					
КонецПроцедуры





					
				