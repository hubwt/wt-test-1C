
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НайденаяПродажа = ЕстьПродажаВЗаявке(Объект.Ссылка);
	Если НайденаяПродажа <> Документы.ПродажаЗапчастей.ПустаяСсылка() Тогда
		ПолучитьДанныеИзПродажиДляЗаявки(НайденаяПродажа);
		Объект.ТипСделки = Перечисления.ТипСделки.Продажа;
		ОбъектЗаявки = РеквизитФормыВЗначение("Объект");
		ОбъектЗаявки.Продажа = НайденаяПродажа;
		ОбъектЗаявки.Записать();
	Иначе
		Объект.ТипСделки = Перечисления.ТипСделки.Заявка;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеИзПродажиДляЗаявки(НайденаяПродажа)
	Объект.Организация = НайденаяПродажа.Организация;
	Объект.Продажа = НайденаяПродажа;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьПродажаВЗаявке(СсылкаНаЗаявку)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПродажаЗапчастей.Ссылка КАК Продажа
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|ГДЕ
		|	ПродажаЗапчастей.ЗаказКлиента = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаЗаявку);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Документы.ПродажаЗапчастей.ПустаяСсылка();
	КонецЕсли;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	
		Возврат ВыборкаДетальныеЗаписи.Продажа;
	КонецЦикла;
	
КонецФункции


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаПродажа Тогда
		НайденаяПродажа = ЕстьПродажаВЗаявке(Объект.Ссылка);
		Если НайденаяПродажа <> Документы.ПродажаЗапчастей.ПустаяСсылка() Тогда
			ПолучитьДанныеИзПродажиДляЗаявки(НайденаяПродажа);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ТекДанные.Количество 	= 1;
	ТекДанные.Склад 	= Объект.Склад;
	ТекДанные.Цена 		 	= дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьРекомендованнуюЦену(ТекДанные.Номенклатура, Объект.Дата);
	ТекДанные.Сумма 			= ТекДанные.Цена * ТекДанные.Количество;
	
КонецПроцедуры




&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Товары", "Цена");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияПриИзменении(Элемент)
	
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	ОткрытьФорму("ОбщаяФорма.СписокНоменклатурыЦенообразования");
КонецПроцедуры




&НаКлиенте
Процедура СоздатьКарточкуТовара(Команда)
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлементаПростая");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзФайла(Команда)
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выбор файла";
	Диалог.Фильтр = "Excel файлы(*.xls;*.xlsx)|*.xls;*.xlsx";
	Диалог.ИндексФильтра = 0;
	Диалог.ПредварительныйПросмотр = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор = Ложь; 
	//Диалог.ПолноеИмяФайла = ПутьКФайлу;
	
	Если Диалог.Выбрать() Тогда
		Попытка
			Эксель = Новый COMОбъект("Excel.Application");
			Эксель.DisplayAlerts = 0;
			Эксель.Visible = 0;
		Исключение
			Сообщить(ОписаниеОшибки()); 
			Возврат;
		КонецПопытки;
		
		ЭксельКнига = Эксель.Workbooks.Open(Диалог.ПолноеИмяФайла);	
		КоличествоСтраниц = ЭксельКнига.Sheets.Count;
		
		// Перебираем все листы
		Для НомерЛиста = 1 По КоличествоСтраниц Цикл 
			Лист = ЭксельКнига.Sheets(НомерЛиста);
			КоличествоСтрок = Лист.Cells(1, 1).SpecialCells(11).Row;
			КоличествоКолонок = Лист.Cells(1, 1).SpecialCells(11).Column;
			
			// Перебираем строки
			Для НомерСтроки = 2 По КоличествоСтрок Цикл 
				артикулДетали = Строка(Лист.Cells(НомерСтроки, 1).Text); 
				артикулДетали = СокрЛП(СтрЗаменить(артикулДетали," ",""));
				ЗаполнитьИзФайлаНаСервере(артикулДетали);
				
			КонецЦикла;	
		КонецЦикла;
		
		Эксель.Workbooks.Close();
		Эксель.Application.Quit();
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзФайлаНаСервере(артикулДетали)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.РекомендованаяЦена КАК Цена
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Артикул = &Артикул";
	
	Запрос.УстановитьПараметр("Артикул", артикулДетали);
	ВыборкаДеталей = Запрос.Выполнить().Выбрать();

	Если ВыборкаДеталей.Количество() = 0 Тогда
		Сообщить("Товар с артикулом " + артикулДетали + " не найден!" );
	КонецЕсли;  
	
	Если ВыборкаДеталей.Количество() > 1 Тогда
		Сообщить("Товар с артикулом " + артикулДетали + " найден в количестве " + ВыборкаДеталей.Количество() + " шт." );
	КонецЕсли;
	
	Пока ВыборкаДеталей.Следующий() Цикл		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.склад = Объект.Склад;
		НоваяСтрока.Номенклатура = ВыборкаДеталей.Номенклатура;
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Цена = ВыборкаДеталей.Цена;
		НоваяСтрока.Сумма = ВыборкаДеталей.Цена;
	КонецЦикла;
КонецПроцедуры



&НаКлиенте
Процедура НарядНаСборкуКод(Команда)
	Если ЗначениеЗаполнено(Объект.Продажа) Тогда
		Записать();
		ПараметрыФормы = Новый Структура("Ключ", Объект.Продажа);
		ФормаПродажи = ПолучитьФорму("Документ.ПродажаЗапчастей.Форма.ФормаДокумента", ПараметрыФормы);
		ТабДокумент  = ФормаПродажи.НарядНаСборкуСервер("Код");
		ТабДокумент.Показать();
	Иначе
		Сообщить("Продажа не создана.");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НарядыНаСборкуМесто(Команда)
	
	Если ЗначениеЗаполнено(Объект.Продажа) Тогда
		Записать();
		ПараметрыФормы = Новый Структура("Ключ", Объект.Продажа);
		ФормаПродажи = ПолучитьФорму("Документ.ПродажаЗапчастей.Форма.ФормаДокумента", ПараметрыФормы);
		ТабДокумент  = ФормаПродажи.НарядНаСборкуСервер("Место");
		ТабДокумент.Показать();
	Иначе
		Сообщить("Продажа не создана.");
	КонецЕсли;
КонецПроцедуры
#КонецОбласти


&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	Штрихкод = Получитькомпоненту();  
	Элементы.QRКод.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	
КонецПроцедуры  

&НаСервере
Функция Получитькомпоненту()
	
	ТекстОшибки = "";
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(ТекстОшибки); 
	Штрихкод.Ширина = 300; 
	Штрихкод.Высота = 300;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = Объект.Номер;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод, Истина);
	
	QRкод = ПоместитьВоВременноеХранилище(КартинкаШтрихКод,УникальныйИдентификатор);
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьПродажуНаСервере()
	
	
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ТипСделки = Перечисления.ТипСделки.Продажа И Объект.Продажа = Документы.ПродажаЗапчастей.ПустаяСсылка() Тогда
		СоздатьПродажу();	
	КонецЕсли;
	
	Если Объект.Продажа <> Документы.ПродажаЗапчастей.ПустаяСсылка() Тогда
		ОбновитьПродажу();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПродажу()
	НовыйДокумент = Документы.ПродажаЗапчастей.СоздатьДокумент();
	НовыйДокумент.Дата = ТекущаяДатаСеанса();
	НовыйДокумент.Клиент = Объект.Клиент;
	НовыйДокумент.ЗаказКлиента = Объект.Ссылка;
	НовыйДокумент.СтатусДоставки = Перечисления.СтатусОтправки.Отправлен;
	НовыйДокумент.ОжидаемаяДатаВыплаты = ТекущаяДата();
	НовыйДокумент.Организация = Объект.Организация;
	НовыйДокумент.КтоПродал = Объект.Ответственный;
	
	Для Каждого СтрокаТЧЗаявки Из Объект.Товары Цикл
		НоваяСтрока = НовыйДокумент.Таблица.Добавить();
		НоваяСтрока.Партия = СтрокаТЧЗаявки.Партия;
		НоваяСтрока.Товар = СтрокаТЧЗаявки.Номенклатура;
		НоваяСтрока.МестоХранения = ПолучитьАдрес(СтрокаТЧЗаявки.Номенклатура, СтрокаТЧЗаявки.Склад, СтрокаТЧЗаявки.Партия);
		НоваяСтрока.Количество = СтрокаТЧЗаявки.Количество;
		НоваяСтрока.Цена = СтрокаТЧЗаявки.Цена;
		НоваяСтрока.Склад = СтрокаТЧЗаявки.Склад;
		НоваяСтрока.СуммаНДС = СтрокаТЧЗаявки.СуммаНДС;
		НоваяСтрока.Сумма = СтрокаТЧЗаявки.Сумма;	
		НоваяСтрока.Отменено = СтрокаТЧЗаявки.Отменено;
		НоваяСтрока.СтатусТовара = СтрокаТЧЗаявки.Выдача;
	КонецЦикла;
	
	НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	
	ПолучитьДанныеИзПродажиДляЗаявки(Документы.ПродажаЗапчастей.НайтиПоНомеру(НовыйДокумент.Номер));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПродажу()
		ОбъектПродажа = Объект.Продажа.ПолучитьОбъект();
		ОбъектПродажа.Организация = Объект.Организация;
		ОбъектПродажа.КтоПродал = Объект.Ответственный;
		ОбъектПродажа.Таблица.Очистить();
		Для Каждого СтрокаТЧЗаявки Из Объект.Товары Цикл
			НоваяСтрока = ОбъектПродажа.Таблица.Добавить();
			НоваяСтрока.Партия = СтрокаТЧЗаявки.Партия;
			НоваяСтрока.Товар = СтрокаТЧЗаявки.Номенклатура;
			НоваяСтрока.МестоХранения = ПолучитьАдрес(СтрокаТЧЗаявки.Номенклатура, СтрокаТЧЗаявки.Партия , СтрокаТЧЗаявки.Склад);
			НоваяСтрока.Склад = СтрокаТЧЗаявки.Склад;
			НоваяСтрока.Количество = СтрокаТЧЗаявки.Количество;
			НоваяСтрока.Цена = СтрокаТЧЗаявки.Цена;
			НоваяСтрока.СуммаНДС = СтрокаТЧЗаявки.СуммаНДС;
			НоваяСтрока.Сумма = СтрокаТЧЗаявки.Сумма;	
			НоваяСтрока.Отменено = СтрокаТЧЗаявки.Отменено;
			НоваяСтрока.СтатусТовара = СтрокаТЧЗаявки.Выдача;
		КонецЦикла;
		ОбъектПродажа.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
				ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе
			ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
			ТекДанные.СуммаНДС = 0;
	КонецЕсли;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьАдрес(Номенклатура, Склад, ИндКод)  
	Запрос  = Новый запрос;
	Запрос. текст = "ВЫБРАТЬ
	|	дт_МестаХраненияНоменклатурыСрезПоследних.МестоХранения КАК МестоХранения,
	|	ЕСТЬNULL(Стеллажик.ГруппаМестХранения, ЗНАЧЕНИЕ(Справочник.ГруппыМестХранения.ПустаяСсылка)) КАК ГруппаМестХранения,
	|	ВЫБОР
	|		КОГДА ИндНомер.Стеллаж <> ЗНАЧЕНИЕ(Справочник.стеллаж.пустаяссылка)
	|			ТОГДА ИндНомер.Стеллаж
	|		ИНАЧЕ Стеллажик.Ссылка
	|	КОНЕЦ КАК Стеллаж
	|ИЗ
	|	РегистрСведений.дт_МестаХраненияНоменклатуры.СрезПоследних(
	|			&ДатаСреза,
	|			Склад = &Склад
	|				И Номенклатура = &Номенклатура) КАК дт_МестаХраненияНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Стеллаж КАК Стеллажик
	|		ПО дт_МестаХраненияНоменклатурыСрезПоследних.МестоХранения = Стеллажик.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО дт_МестаХраненияНоменклатурыСрезПоследних.Номенклатура = ИндНомер.индкод.Владелец
	|ГДЕ
	|	ИндНомер.индкод = &индкод";
	
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("индкод",ИндКод);
	Запрос.УстановитьПараметр("ДатаСреза",ТекущаяДата());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Возврат Выборка.стеллаж;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	
КонецФункции




