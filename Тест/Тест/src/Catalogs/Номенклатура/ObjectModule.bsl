#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий


Процедура ПередЗаписью(Отказ)
	
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку")
		И НЕ ЗначениеЗаполнено(ЭтотОбъект.Состояние) Тогда
		
		Состояние = Перечисления.Состояние.Новый; 
		
	КонецЕсли;
	
	ЗаполнитьНомерЗамен();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	///+ТатарМА 07.10.2024
	ЗаписьВРкгистреСведений = РегистрыСведений.ИсторияИзмененияРыночныхЦен.СоздатьМенеджерЗаписи();
	ЗаписьВРкгистреСведений.Товар = Ссылка;
	ЗаписьВРкгистреСведений.Дата = ТекущаяДатаСеанса();
	ЗаписьВРкгистреСведений.ВерхняяЦена = ВерхняяЦена;
	ЗаписьВРкгистреСведений.СредняяЦена = СредняяЦена;
	ЗаписьВРкгистреСведений.НижняяЦена = НижняяЦена;
	ЗаписьВРкгистреСведений.ВерхняяЦенаСоСнижением = ВерхняяЦенаСоСнижением;
	ЗаписьВРкгистреСведений.СредняяЦенаСоСнижением = СредняяЦенаСоСнижением;
	ЗаписьВРкгистреСведений.НижняяЦенаСоСнижением = НижняяЦенаСоСнижением;
	ЗаписьВРкгистреСведений.ПроцентСнижения = ПроцентСниженияЦены;
	ЗаписьВРкгистреСведений.Ответственный = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
	ЗаписьВРкгистреСведений.Записать();
	///-ТатарМА 07.10.2024
	
	///+ТатарМА 09.12.2024
	Если УбратьИзАвтозагрузкиАвито Тогда
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) КАК КоличествоЗаявок,
	|	ИндНомер.индкод.Владелец.Ссылка КАК Номенклатура,
	|	ИндНомер.индкод КАК индкод,
	|	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток,
	|	РегистрНакопления1Остатки.Склад КАК Склад
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО (ИндНомер.индкод.Владелец = ТоварыИзЗаявок.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ПО (ИндНомер.индкод = РегистрНакопления1Остатки.индкод)
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|	И ИндНомер.АвитоЧастник
	|	И ТоварыИзЗаявок.КоличествоЗаявок > 0
	|	И ИндНомер.индкод.Владелец <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ИндНомер.Цена > 0
	|	И ИндНомер.ЕстьФото = ИСТИНА
	|	И ИндНомер.Стеллаж <> &Стеллаж
	|	И ВЫБОР
	|		КОГДА НЕ ИндНомер.индкод.Владелец.Подкатегория2 В (&Категории)
	|			ТОГДА НЕ РегистрНакопления1Остатки.машина.Серия = ЗНАЧЕНИЕ(Справочник.Серии.ПустаяСсылка)
	|		ИНАЧЕ
	|		НЕ (ИндНомер.индкод.Владелец.Бренд = ЗНАЧЕНИЕ(Справочник.Бренд.ПустаяСсылка)
	|		ИЛИ ИндНомер.индкод.Владелец.МодельШин = ЗНАЧЕНИЕ(Справочник.МоделиШин.ПустаяСсылка)
	|		ИЛИ ИндНомер.индкод.Владелец.ВысотаШин = ЗНАЧЕНИЕ(Справочник.ВысотаШин.ПустаяСсылка)
	|		ИЛИ ИндНомер.индкод.Владелец.ШиринаШин = ЗНАЧЕНИЕ(Справочник.ШиринаШин.ПустаяСсылка)
	|		ИЛИ ИндНомер.индкод.Владелец.ДиаметрШин = ЗНАЧЕНИЕ(Справочник.ДиаметрШин.ПустаяСсылка)
	|		ИЛИ ИндНомер.индкод.Владелец.ИндексНагрузки = 0
	|		ИЛИ ИндНомер.индкод.Владелец.ИндексСкорости = НЕОПРЕДЕЛЕНО
	|		ИЛИ ИндНомер.индкод.Владелец.ОсьШин = НЕОПРЕДЕЛЕНО
	|		ИЛИ ИндНомер.индкод.Владелец.СезонностьШин = НЕОПРЕДЕЛЕНО
	|		ИЛИ ИндНомер.индкод.Владелец.Состояние = НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ
	|	И ИндНомер.Поддон <> &Поддон
	|	И ИндНомер.Стеллаж.ГруппаМестХранения <> &ГруппаМестХранения
	|	И ИндНомер.индкод.Владелец = &Номенклатура";

	МассивКатегорийШин = Новый Массив;
	МассивКатегорийШин.Добавить(Справочники.Категории.НайтиПоКоду("000000501"));
	МассивКатегорийШин.Добавить(Справочники.Категории.НайтиПоКоду("000000502"));

	Запрос.УстановитьПараметр("Поддон", Справочники.Поддоны.НайтиПоКоду("000000003")); // П0003 потеряшки);
	Запрос.УстановитьПараметр("ГруппаМестХранения", Справочники.ГруппыМестХранения.НайтиПоКоду("000000002")); //B-KOMPL
	Запрос.УстановитьПараметр("Стеллаж", Справочники.Стеллаж.НайтиПоКоду("000001072"));
	Запрос.УстановитьПараметр("Категории", МассивКатегорийШин);
	Запрос.УстановитьПараметр("Номенклатура", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		ЗаписьВРегистреСведений 		= РегистрыСведений.ИндНомер.СоздатьМенеджерЗаписи();
		ЗаписьВРегистреСведений.индкод 	= Справочники.ИндКод.НайтиПоНаименованию(Выборка.индкод);
		ЗаписьВРегистреСведений.Прочитать();
		Если ЗаписьВРегистреСведений.Выбран() Тогда
			ЗаписьВРегистреСведений.УбратьИзАвтозагрузкиАвито = Истина;
			ЗаписьВРегистреСведений.Записать();
		КонецЕсли;
	КонецЦикла;
	КонецЕсли;
	///-ТатарМА 09.12.2024
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	
	ДатаСоздания = '00010101';
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат
	КонецЕсли;
	
	
	// проверим уникальность городов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СвойстваПоГородам.Город КАК Город,
		|	СвойстваПоГородам.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_СвойстваПоГородам
		|ИЗ
		|	&СвойстваПоГородам КАК СвойстваПоГородам
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Город
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СвойстваПоГородам.Город КАК Город,
		|	МИНИМУМ(ВТ_СвойстваПоГородам.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	ВТ_СвойстваПоГородам КАК ВТ_СвойстваПоГородам
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_СвойстваПоГородам.Город
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(ВТ_СвойстваПоГородам.НомерСтроки) > 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("СвойстваПоГородам", СвойстваПоГородам.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвойстваПоГородам", ВыборкаДетальныеЗаписи.НомерСтроки, "Город");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Строка %1. Неоднозначно определены свойства для города %2",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				ВыборкаДетальныеЗаписи.Город),
			ЭтотОбъект,
			Поле,
			"Объект",
			Отказ
		);
				
	КонецЦикла;
	

	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНомерЗамен() Экспорт

	НомерЗаменИндекс = "";
	
	Если НомераЗамен.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из НомераЗамен Цикл
	
		НомерЗаменИндекс = НомерЗаменИндекс + СтрокаТаблицы.НомерЗамены + ", ";	
	
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(НомерЗаменИндекс, 2);

КонецПроцедуры
Функция ЗаполнениеТаблПредложениеСвязанныхНоменклатур()
	
	//++МазинЕС-18-07-2024
	
	//Добавление в Массив ссылок из таблицы Предложения
	МассивСсылокПредложение = Новый Массив; 
	Для Каждого Строка ИЗ Предложения Цикл 
		МассивСсылокПредложение.Добавить(Строка.Реквизит1); 
	КонецЦикла; 
	//Конец - Добавление в Массив ссылок из таблицы Предложения
		
	// Добаление предложений корневого элемента в элемент первой вложенности с проверкой на дубли	
		 
Если МассивСсылокПредложение.Количество() > 0 Тогда 
	Для каждого СтрокаМас Из МассивСсылокПредложение Цикл 			
		ДокОбъект = СтрокаМас.ПолучитьОбъект();			
		Если ДокОбъект.Предложения.Количество() = 0 Тогда
			Флаг = Истина;
		КонецЕсли;		
				Для каждого СтрокаМас Из МассивСсылокПредложение Цикл 
						Если СтрокаМас <> ДокОбъект.ссылка Тогда  
						Для Каждого Строка ИЗ ДокОбъект.Предложения Цикл 
							Если Строка.Реквизит1 = СтрокаМас Тогда 
								Флаг = Ложь;
								Прервать;  
							Иначе Флаг = Истина;
							КонецЕсли; 
						КонецЦикла;
					
						Если Флаг = Истина Тогда 
						НоваяСтрока = ДокОбъект.Предложения.Добавить();
						НоваяСтрока.Реквизит1 = СтрокаМас; 	
						ТоварСтруктура 								=ПредложенияРеквизит1ПриИзмененииНаСервере(НоваяСтрока.Реквизит1);
						НоваяСтрока.Наличие 						=ТоварСтруктура.КолвоОстаток;   
						НоваяСтрока.ЦенаТЧ							=ТоварСтруктура.РекомендованаяЦена; 
						НоваяСтрока.ПроцентМенеджераНаНеЛиквидТЧ 	=ТоварСтруктура.ПроцентМенеджераНаНеЛекивд;  
						НоваяСтрока.ЗПМенеджераНаНеЛиквидТЧ			=ТоварСтруктура.ЗПМеджераНаНеликвид;  
						НоваяСтрока.ВКассуНеЛиквидТЧ 				=ТоварСтруктура.ВКассуНеЛиквид;
						КонецЕсли;
						КонецЕсли;
				КонецЦикла;
		//++
						Для Каждого Строка ИЗ ДокОбъект.Предложения Цикл 
							Если Строка.Реквизит1 = Ссылка Тогда 
								Флаг = Ложь;
								Прервать;  
							Иначе Флаг = Истина;
							КонецЕсли; 
						КонецЦикла;
					
						Если Флаг = Истина Тогда 
						НоваяСтрока = ДокОбъект.Предложения.Добавить();
						НоваяСтрока.Реквизит1 = Ссылка; 	
						ТоварСтруктура 								=ПредложенияРеквизит1ПриИзмененииНаСервере(НоваяСтрока.Реквизит1);
						НоваяСтрока.Наличие 						=ТоварСтруктура.КолвоОстаток;   
						НоваяСтрока.ЦенаТЧ							=ТоварСтруктура.РекомендованаяЦена; 
						НоваяСтрока.ПроцентМенеджераНаНеЛиквидТЧ 	=ТоварСтруктура.ПроцентМенеджераНаНеЛекивд;  
						НоваяСтрока.ЗПМенеджераНаНеЛиквидТЧ			=ТоварСтруктура.ЗПМеджераНаНеликвид;  
						НоваяСтрока.ВКассуНеЛиквидТЧ 				=ТоварСтруктура.ВКассуНеЛиквид;
						КонецЕсли;	
		//--		
		Попытка 
			ДокОбъект.Записать();
		Исключение
		КонецПопытки;		
	КонецЦикла;
КонецЕсли;
//--МазинЕС-18-07-2024	
КонецФункции

Функция ПредложенияРеквизит1ПриИзмененииНаСервере(СсылкаНоменклатура)
	//++ МазинЕс 10-06-24

	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА РегистрНакопления1Остатки.КолвоОстаток ЕСТЬ NULL
		|			ТОГДА ЕСТЬNULL(РегистрНакопления1Остатки.КолвоОстаток, 0)
		|		ИНАЧЕ РегистрНакопления1Остатки.КолвоОстаток
		|	КОНЕЦ КАК КолвоОстаток,
		|	ВЫБОР
		|		КОГДА Номенклатура.РекомендованаяЦена ЕСТЬ NULL
		|			ТОГДА ЕСТЬNULL(Номенклатура.РекомендованаяЦена, 0)
		|		ИНАЧЕ Номенклатура.РекомендованаяЦена
		|	КОНЕЦ КАК РекомендованаяЦена,
		|	ВЫБОР
		|		КОГДА Номенклатура.ВКассуНеЛиквид ЕСТЬ NULL
		|			ТОГДА ЕСТЬNULL(Номенклатура.ВКассуНеЛиквид, 0)
		|		ИНАЧЕ Номенклатура.ВКассуНеЛиквид
		|	КОНЕЦ КАК ВКассуНеЛиквид,
		|	ВЫБОР
		|		КОГДА Номенклатура.ПроцентМенеджераНаНеЛиквид ЕСТЬ NULL
		|			ТОГДА ЕСТЬNULL(Номенклатура.ПроцентМенеджераНаНеЛиквид, 0)
		|		ИНАЧЕ Номенклатура.ПроцентМенеджераНаНеЛиквид
		|	КОНЕЦ КАК ПроцентМенеджераНаНеЛекивд,
		|	ВЫБОР
		|		КОГДА Номенклатура.ЗПМенеджераНаНеЛиквид ЕСТЬ NULL
		|			ТОГДА ЕСТЬNULL(Номенклатура.ЗПМенеджераНаНеЛиквид, 0)
		|		ИНАЧЕ Номенклатура.ЗПМенеджераНаНеЛиквид
		|	КОНЕЦ КАК ЗПМеджераНаНеликвид
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|		ПРАВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|		ПО (РегистрНакопления1Остатки.Товар = Номенклатура.Ссылка)
		|ГДЕ
		|	Номенклатура.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",СсылкаНоменклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ТоварСтруктура = Новый Структура(); 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если  ВыборкаДетальныеЗаписи.КолвоОстаток = 0 Тогда 
				ТоварСтруктура.Вставить("КолвоОстаток",0); 
			иначе 
				ТоварСтруктура.Вставить("КолвоОстаток",ВыборкаДетальныеЗаписи.КолвоОстаток);
			ТоварСтруктура.Вставить("РекомендованаяЦена",ВыборкаДетальныеЗаписи.РекомендованаяЦена);
			ТоварСтруктура.Вставить("ПроцентМенеджераНаНеЛекивд",ВыборкаДетальныеЗаписи.ПроцентМенеджераНаНеЛекивд);
			ТоварСтруктура.Вставить("ЗПМеджераНаНеликвид",ВыборкаДетальныеЗаписи.ЗПМеджераНаНеликвид);
			ТоварСтруктура.Вставить("ВКассуНеЛиквид",ВыборкаДетальныеЗаписи.ВКассуНеЛиквид);
			КонецЕсли; 
					ТоварСтруктура.Вставить("КолвоОстаток",ВыборкаДетальныеЗаписи.КолвоОстаток);
			ТоварСтруктура.Вставить("РекомендованаяЦена",ВыборкаДетальныеЗаписи.РекомендованаяЦена);
			ТоварСтруктура.Вставить("ПроцентМенеджераНаНеЛекивд",ВыборкаДетальныеЗаписи.ПроцентМенеджераНаНеЛекивд);
			ТоварСтруктура.Вставить("ЗПМеджераНаНеликвид",ВыборкаДетальныеЗаписи.ЗПМеджераНаНеликвид);
			ТоварСтруктура.Вставить("ВКассуНеЛиквид",ВыборкаДетальныеЗаписи.ВКассуНеЛиквид);
	КонецЦикла;
		
		Возврат ТоварСтруктура; 
	
	//-- МазинЕс 10-06-24
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	//ПроверкаЦены();
	
//	Если ОбменДанными.Загрузка Тогда
//		Возврат
//	КонецЕсли;
	
//	ЗаполнениеТаблПредложениеСвязанныхНоменклатур(); 
	
КонецПроцедуры

Процедура КорректировкаЦены()
 ЗапросИнкода = новый Запрос;
 ЗапросИнкода.текст = "ВЫБРАТЬ
 |	РегистрНакопления1Остатки.Товар КАК Товар,
 |	РегистрНакопления1Остатки.индкод КАК индкод,
 |	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток,
 |	РегистрНакопления1Остатки.Склад КАК Склад,
 |	ИндНомер.Цена КАК Цена
 |ИЗ
 |	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
 |		ПО РегистрНакопления1Остатки.индкод = ИндНомер.индкод
 |ГДЕ
 |	РегистрНакопления1Остатки.Товар = &Товар";
 ЗапросИнкода.УстановитьПараметр("Товар",Ссылка);
 
 Выборка  = ЗапросИнкода.Выполнить().Выбрать();
 
 Если Выборка.Количество() > 0 Тогда
	 Пока Выборка.Следующий() Цикл 
		 
	 КонецЦикла;
 КонецЕсли;
 	 
КонецПроцедуры




#КонецОбласти

#КонецЕсли