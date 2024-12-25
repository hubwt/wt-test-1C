Процедура ПереченьНоменклатурыJSON() Экспорт
	// КомлевАА +_++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Наименование,
	|	Номенклатура.Код,
	|	Номенклатура.Артикул
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура";

	РезультатЗапроса = Запрос.Выполнить();

	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		МассивТоваров  = Новый Массив;

		Пока Выборка.Следующий() Цикл
			СтруктураОтвета = Новый Структура;
			СтруктураОтвета.Вставить("name", Выборка.Наименование);
			СтруктураОтвета.Вставить("code", Выборка.Код);
			СтруктураОтвета.Вставить("article", Выборка.Артикул);
			МассивТоваров.Добавить(СтруктураОтвета);
		КонецЦикла;
	КонецЕсли;
	Запись = Новый ЗаписьJSON;
	Запись.ОткрытьФайл("\\nas\Backup1c\Комлев\Товары.json");
	ЗаписатьJSON(Запись, МассивТоваров);
	Запись.Закрыть();
	// КомлевАА ----
КонецПроцедуры

Процедура ВыгрузитьТоварыВJSON() Экспорт
// КомлевАА +_++
	ЗапросТоваров = Новый Запрос;
	ЗапросТоваров.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1000000
	|	СпрИндКод.Владелец.Наименование КАК Наименование,
	|	СпрИндКод.Владелец.Артикул КАК Артикул,
	|	РегистрИндНомер.индкод КАК индкод,
	|	ВЫБОР
	|		КОГДА РегистрИндНомер.Цена > 0
	|			ТОГДА РегистрИндНомер.Цена
	|		ИНАЧЕ СпрИндКод.Владелец.РекомендованаяЦена
	|	КОНЕЦ КАК Цена,
	|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
	|	РегистрНакопления1Остатки.машина.Серия КАК Серия
	|ПОМЕСТИТЬ СНомеромЗаписи
	|ИЗ
	|	РегистрСведений.ИндНомер КАК РегистрИндНомер
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИндКод КАК СпрИндКод
	|		ПО (РегистрИндНомер.индкод = СпрИндКод.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ПО (РегистрНакопления1Остатки.индкод = РегистрИндНомер.индкод)
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|	И РегистрИндНомер.ЕстьФото = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК Спрос
	|ПОМЕСТИТЬ СпросНаТовар
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СНомеромЗаписи.Наименование КАК Наименование,
	|	СНомеромЗаписи.Артикул КАК Артикул,
	|	СНомеромЗаписи.индкод КАК индкод,
	|	СНомеромЗаписи.Цена КАК Цена,
	|	СНомеромЗаписи.НомерЗаписи КАК НомерЗаписи,
	|	ЕСТЬNULL(СпросНаТовар.Спрос, 0) КАК Спрос,
	|	СНомеромЗаписи.Серия КАК Серия
	|ИЗ
	|	СНомеромЗаписи КАК СНомеромЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ СпросНаТовар КАК СпросНаТовар
	|		ПО (СНомеромЗаписи.индкод.Владелец.Ссылка = СпросНаТовар.Номенклатура)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЗаписи";
	
//	ДатаМесяцНазад = ДобавитьМесяц(ТекущаяДатаСеанса(), -1);
//	ЗапросТоваров.УстановитьПараметр("ДатаМесяцНазад", ДатаМесяцНазад);
	ДеталиТЗ = ЗапросТоваров.Выполнить().Выгрузить();
	
	КоличествоДеталей = ДеталиТЗ.Количество();
	МассивТоваров = Новый массив;	
	КонечныйНомер = КоличествоДеталей;	
	КонечноеЗначение = 1;
	Для НомерЗаписи = 0 По КонечныйНомер Цикл		
		НомерЗаписи = НомерЗаписи + 1000;
		ЧастьДеталей = Новый Массив; 
		МассивИндкод  = Новый Массив;
		Если НомерЗаписи > КонечныйНомер Тогда
			НомерЗаписи = КонечныйНомер;
		КонецЕсли;
		Для Сч = КонечноеЗначение По НомерЗаписи Цикл
			ЧастьДеталей.Добавить(ДеталиТЗ[Сч - 1]);
			МассивИндкод.Добавить(Строка(ДеталиТЗ[Сч - 1].индкод));
		КонецЦикла;
		КонечноеЗначение = НомерЗаписи + 1;  
		ФоткиИндкод = РаботаССайтомWT.ПолучениеФотоБезИндНомер(МассивИндкод); 
		Для Каждого Выборка Из ЧастьДеталей Цикл 
			Для Каждого Строка Из ФоткиИндкод Цикл
				
				Если Строка.indCode = Строка(Выборка.индкод) Тогда
					СтруктураТоваров = Новый Структура;
					
					Если Строка.urls.Количество() > 0 Тогда
						Структура = Новый Структура;
						Структура.Вставить("id", Строка.indCode);
						Фото = Строка.urls[0];
						СтруктураТоваров.Вставить("name", Строка(Выборка.Наименование));
						СтруктураТоваров.Вставить("article", Строка(Выборка.Артикул));
						СтруктураТоваров.Вставить("id", Строка(Выборка.индкод));
						СтруктураТоваров.Вставить("price", Число(Выборка.Цена));
						СтруктураТоваров.Вставить("photo", Фото);
						СтруктураТоваров.Вставить("popularity", Выборка.Спрос);
						СтруктураТоваров.Вставить("series", Выборка.Серия);
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;  
			Если ЗначениеЗаполнено(СтруктураТоваров) Тогда
				МассивТоваров.Добавить(СтруктураТоваров); 
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;	
	
	Запись = Новый ЗаписьJSON;
	Запись.ОткрытьФайл("\\nas\Backup1c\common\verified_products.json");
	ЗаписатьJSON(Запись, МассивТоваров);
	Запись.Закрыть();
	// КомлевАА ---

КонецПроцедуры

#Область ПрограммныйИнтерфейс
Функция Просклонять(Слово, Падеж) Экспорт

	Возврат дт_ОбщегоНазначенияПовтИсп.Просклонять(Слово, Падеж);

КонецФункции

Функция ПолучитьСуммуДокументов(Знач Коллекция) Экспорт

	Возврат дт_ОбщегоНазначения.ПолучитьСуммуДокументов(Коллекция);

КонецФункции // ПолучитьСуммуДокументов()

Функция ПолучитьСсылкуПоУИ(УИ, ИмяОбъекта) Экспорт

	Результат = Неопределено;
	
	Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
		Результат = Документы[ИмяОбъекта].ПолучитьСсылку(УИ);
	ИначеЕсли Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
		Результат = Справочники[ИмяОбъекта].ПолучитьСсылку(УИ);
	КонецЕсли;
	
	Возврат Результат;
	

КонецФункции // ПолучитьСсылкуПоУИ()


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти