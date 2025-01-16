
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	СтраницыПриСменеСтраницыНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	Прочитать();
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
#КонецОбласти


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СкрытьВидимостьКомандыСоздатьНаОсновании();    
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
	НовыйДокумент.Организация = Справочники.Организация.НайтиПоКоду("000000010");
	
	Для Каждого СтрокаТЧЗаявки Из Объект.Товары Цикл
		НоваяСтрока = НовыйДокумент.Таблица.Добавить();
		НоваяСтрока.Партия = СтрокаТЧЗаявки.Партия;
		НоваяСтрока.Товар = СтрокаТЧЗаявки.Номенклатура;
		НоваяСтрока.Количество = СтрокаТЧЗаявки.Количество;
		НоваяСтрока.Цена = СтрокаТЧЗаявки.Цена;
		НоваяСтрока.Склад = СтрокаТЧЗаявки.Склад;
		НоваяСтрока.СуммаНДС = СтрокаТЧЗаявки.СуммаНДС;
		НоваяСтрока.Сумма = СтрокаТЧЗаявки.Сумма;	
		НоваяСтрока.Отменено = СтрокаТЧЗаявки.Отменено;
		НоваяСтрока.СтатусТовара = СтрокаТЧЗаявки.Выдача;
	КонецЦикла;
	
	НовыйДокумент.Записать();
	
	ОбъектЗаявка = Объект.Ссылка.ПолучитьОбъект();
	ОбъектЗаявка.Продажа = Документы.ПродажаЗапчастей.НайтиПоНомеру(НовыйДокумент.Номер);
	ОбъектЗаявка.Записать();
КонецПроцедуры

&НаСервере
Процедура ОбновитьПродажу()
		ОбъектПродажа = Объект.Продажа.ПолучитьОбъект();
		ОбъектПродажа.Таблица.Очистить();
		Для Каждого СтрокаТЧЗаявки Из Объект.Товары Цикл
			НоваяСтрока = ОбъектПродажа.Таблица.Добавить();
			НоваяСтрока.Партия = СтрокаТЧЗаявки.Партия;
			НоваяСтрока.Товар = СтрокаТЧЗаявки.Номенклатура;
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


Процедура СкрытьВидимостьКомандыСоздатьНаОсновании() 
	Для каждого ЭлементКоманднойПанели Из КоманднаяПанель.ПодчиненныеЭлементы Цикл    
		Если ЭлементКоманднойПанели = КоманднаяПанель.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании Тогда 
			ЭлементКоманднойПанели.Видимость = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
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




