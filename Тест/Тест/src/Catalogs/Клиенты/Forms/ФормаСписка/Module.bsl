
&НаКлиенте
Процедура Поиск(Команда)
	// Вставить содержимое обработчика.
	Фильтр();
КонецПроцедуры


&НаСервере
Функция РазбитьСтрокуНаМассивПодстрок(ИсходнаяСтрока,РазделительСтрок)
   СтрокаДляРазбора = ИсходнаяСтрока;
   СтрокаДляРазбора = СтрЗаменить(СтрокаДляРазбора, РазделительСтрок, Символы.ПС);
   МассивСтрок = новый Массив;
   КолвоСтрок = СтрЧислоСтрок(СтрокаДляРазбора);
   Для НомСтр = 1 По КолвоСтрок Цикл
      МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаДляРазбора, НомСтр));
  КонецЦикла;
   Возврат МассивСтрок;
КонецФункции

&НаСервере
Функция Фильтр() Экспорт
	Перем а;
	Мас = РазбитьСтрокуНаМассивПодстрок(Поиск," ");
	Кол = Мас.Количество();
	Коды = Новый Массив();
	Запрос = Новый Запрос();
	ПоискПо = "ГДЕ "; 
Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;
	
Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.ФИО ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.ФИО ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;

	Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.Телефон ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.Телефон ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;
	
	Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.Город ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.Город ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;
	
	Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.Область.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.Область.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;
	
	Если Кол > 0 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникКлиенты.ДополнительныеКонтакты.Телефон ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникКлиенты.ДополнительныеКонтакты.Телефон ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;

	
	Список.ТекстЗапроса = "ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Продажи.Регистратор.Ссылка) КАК РегистраторСсылка,
	                      |	Продажи.Регистратор.Клиент КАК РегистраторКлиент
	                      |ПОМЕСТИТЬ ВТ_КолвоПродаж
	                      |ИЗ
	                      |	РегистрНакопления.Продажи КАК Продажи
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Продажи.Регистратор.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Продажи.Регистратор.Клиент КАК РегистраторКлиент,
	                      |	СУММА(Продажи.Сумма) КАК Сумма
	                      |ПОМЕСТИТЬ ВТ_СуммаПродаж
	                      |ИЗ
	                      |	РегистрНакопления.Продажи КАК Продажи
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Продажи.Регистратор.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК Ссылка,
	                      |	ЗаказКлиента.Клиент КАК Клиент
	                      |ПОМЕСТИТЬ ВТ_Заявки
	                      |ИЗ
	                      |	Документ.ЗаказКлиента КАК ЗаказКлиента
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЗаказКлиента.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЗаказКлиента.Клиент КАК Клиент,
	                      |	СУММА(ЗаказКлиента.СуммаДокумента) КАК СуммаДокумента
	                      |ПОМЕСТИТЬ ВТ_СуммаЗаявок
	                      |ИЗ
	                      |	Документ.ЗаказКлиента КАК ЗаказКлиента
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЗаказКлиента.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникКлиенты.Ссылка КАК Ссылка,
	                      |	СправочникКлиенты.ВерсияДанных КАК ВерсияДанных,
	                      |	СправочникКлиенты.ПометкаУдаления КАК ПометкаУдаления,
	                      |	СправочникКлиенты.Предопределенный КАК Предопределенный,
	                      |	СправочникКлиенты.Код КАК Код,
	                      |	СправочникКлиенты.Наименование КАК Наименование,
	                      |	СправочникКлиенты.ФИО КАК ФИО,
	                      |	СправочникКлиенты.Телефон КАК Телефон,
	                      |	СправочникКлиенты.Страна КАК Страна,
	                      |	СправочникКлиенты.Город КАК Город,
	                      |	СправочникКлиенты.Скидка КАК Скидка,
	                      |	СправочникКлиенты.Комментарий КАК Комментарий,
	                      |	СправочникКлиенты.ПолноеНаименование КАК ПолноеНаименование,
	                      |	СправочникКлиенты.ИНН КАК ИНН,
	                      |	СправочникКлиенты.КПП КАК КПП,
	                      |	СправочникКлиенты.КодПоОКПО КАК КодПоОКПО,
	                      |	СправочникКлиенты.ЮридическийАдрес КАК ЮридическийАдрес,
	                      |	СправочникКлиенты.ФактическийАдрес КАК ФактическийАдрес,
	                      |	СправочникКлиенты.РеквизитТелефон КАК РеквизитТелефон,
	                      |	СправочникКлиенты.Машины.(
	                      |		Ссылка КАК Ссылка,
	                      |		НомерСтроки КАК НомерСтроки,
	                      |		Машина КАК Машина,
	                      |		Комментарий КАК Комментарий
	                      |	) КАК Машины,
	                      |	СправочникКлиенты.ДополнительныеКонтакты.(
	                      |		Ссылка КАК Ссылка,
	                      |		НомерСтроки КАК НомерСтроки,
	                      |		Телефон КАК Телефон,
	                      |		ФИО КАК ФИО,
	                      |		Дополнительно КАК Дополнительно
	                      |	) КАК ДополнительныеКонтакты,
	                      |	СправочникКлиенты.Город2 КАК Город2,
	                      |	СправочникКлиенты.Email КАК Email,
	                      |	СправочникКлиенты.КоличествоАвтомобилей КАК КоличествоАвтомобилей,
	                      |	СправочникКлиенты.Ответственный КАК Ответственный,
	                      |	СправочникКлиенты.ИсточникОбращения КАК ИсточникОбращения,
	                      |	СправочникКлиенты.ВидКлиента КАК ВидКлиента,
	                      |	СправочникКлиенты.ДатаПоследнегоКонтакта КАК ДатаПоследнегоКонтакта,
	                      |	СправочникКлиенты.СтатусКлиента КАК СтатусКлиента,
	                      |	ВТ_Заявки.Ссылка КАК КолвоЗаявок,
	                      |	ВТ_КолвоПродаж.РегистраторСсылка КАК КолвоПродаж,
	                      |	ВТ_СуммаПродаж.Сумма КАК СуммаПродаж,
	                      |	ВТ_СуммаЗаявок.СуммаДокумента КАК СуммаЗаявок,
	                      |	СправочникКлиенты.ДатаСоздания КАК ДатаСоздания
	                      |ИЗ
	                      |	Справочник.Клиенты КАК СправочникКлиенты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КолвоПродаж КАК ВТ_КолвоПродаж
	                      |		ПО (ВТ_КолвоПродаж.РегистраторКлиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СуммаПродаж КАК ВТ_СуммаПродаж
	                      |		ПО (ВТ_СуммаПродаж.РегистраторКлиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Заявки КАК ВТ_Заявки
	                      |		ПО (ВТ_Заявки.Клиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СуммаЗаявок КАК ВТ_СуммаЗаявок
	                      |		ПО (ВТ_СуммаЗаявок.Клиент = СправочникКлиенты.Ссылка)" + ПоискПо;
	Сообщить(Список.ТекстЗапроса);
КонецФункции

&НаКлиенте
Процедура Очистить(Команда)
	// Вставить содержимое обработчика.
	ОчиститьПоиск();
КонецПроцедуры


&НаСервере
Процедура ОчиститьПоиск()
	Список.ТекстЗапроса = "ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Продажи.Регистратор.Ссылка) КАК РегистраторСсылка,
	                      |	Продажи.Регистратор.Клиент КАК РегистраторКлиент
	                      |ПОМЕСТИТЬ ВТ_КолвоПродаж
	                      |ИЗ
	                      |	РегистрНакопления.Продажи КАК Продажи
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Продажи.Регистратор.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Продажи.Регистратор.Клиент КАК РегистраторКлиент,
	                      |	СУММА(Продажи.Сумма) КАК Сумма
	                      |ПОМЕСТИТЬ ВТ_СуммаПродаж
	                      |ИЗ
	                      |	РегистрНакопления.Продажи КАК Продажи
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Продажи.Регистратор.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК Ссылка,
	                      |	ЗаказКлиента.Клиент КАК Клиент
	                      |ПОМЕСТИТЬ ВТ_Заявки
	                      |ИЗ
	                      |	Документ.ЗаказКлиента КАК ЗаказКлиента
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЗаказКлиента.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЗаказКлиента.Клиент КАК Клиент,
	                      |	СУММА(ЗаказКлиента.СуммаДокумента) КАК СуммаДокумента
	                      |ПОМЕСТИТЬ ВТ_СуммаЗаявок
	                      |ИЗ
	                      |	Документ.ЗаказКлиента КАК ЗаказКлиента
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЗаказКлиента.Клиент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникКлиенты.Ссылка КАК Ссылка,
	                      |	СправочникКлиенты.ВерсияДанных КАК ВерсияДанных,
	                      |	СправочникКлиенты.ПометкаУдаления КАК ПометкаУдаления,
	                      |	СправочникКлиенты.Предопределенный КАК Предопределенный,
	                      |	СправочникКлиенты.Код КАК Код,
	                      |	СправочникКлиенты.Наименование КАК Наименование,
	                      |	СправочникКлиенты.ФИО КАК ФИО,
	                      |	СправочникКлиенты.Телефон КАК Телефон,
	                      |	СправочникКлиенты.Страна КАК Страна,
	                      |	СправочникКлиенты.Город КАК Город,
	                      |	СправочникКлиенты.Скидка КАК Скидка,
	                      |	СправочникКлиенты.Комментарий КАК Комментарий,
	                      |	СправочникКлиенты.ПолноеНаименование КАК ПолноеНаименование,
	                      |	СправочникКлиенты.ИНН КАК ИНН,
	                      |	СправочникКлиенты.КПП КАК КПП,
	                      |	СправочникКлиенты.КодПоОКПО КАК КодПоОКПО,
	                      |	СправочникКлиенты.ЮридическийАдрес КАК ЮридическийАдрес,
	                      |	СправочникКлиенты.ФактическийАдрес КАК ФактическийАдрес,
	                      |	СправочникКлиенты.РеквизитТелефон КАК РеквизитТелефон,
	                      |	СправочникКлиенты.Машины.(
	                      |		Ссылка КАК Ссылка,
	                      |		НомерСтроки КАК НомерСтроки,
	                      |		Машина КАК Машина,
	                      |		Комментарий КАК Комментарий
	                      |	) КАК Машины,
	                      |	СправочникКлиенты.ДополнительныеКонтакты.(
	                      |		Ссылка КАК Ссылка,
	                      |		НомерСтроки КАК НомерСтроки,
	                      |		Телефон КАК Телефон,
	                      |		ФИО КАК ФИО,
	                      |		Дополнительно КАК Дополнительно
	                      |	) КАК ДополнительныеКонтакты,
	                      |	СправочникКлиенты.Город2 КАК Город2,
	                      |	СправочникКлиенты.Email КАК Email,
	                      |	СправочникКлиенты.КоличествоАвтомобилей КАК КоличествоАвтомобилей,
	                      |	СправочникКлиенты.Ответственный КАК Ответственный,
	                      |	СправочникКлиенты.ИсточникОбращения КАК ИсточникОбращения,
	                      |	СправочникКлиенты.ВидКлиента КАК ВидКлиента,
	                      |	СправочникКлиенты.ДатаПоследнегоКонтакта КАК ДатаПоследнегоКонтакта,
	                      |	СправочникКлиенты.СтатусКлиента КАК СтатусКлиента,
	                      |	ВТ_Заявки.Ссылка КАК КолвоЗаявок,
	                      |	ВТ_КолвоПродаж.РегистраторСсылка КАК КолвоПродаж,
	                      |	ВТ_СуммаПродаж.Сумма КАК СуммаПродаж,
	                      |	ВТ_СуммаЗаявок.СуммаДокумента КАК СуммаЗаявок,
	                      |	СправочникКлиенты.ДатаСоздания КАК ДатаСоздания
	                      |ИЗ
	                      |	Справочник.Клиенты КАК СправочникКлиенты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КолвоПродаж КАК ВТ_КолвоПродаж
	                      |		ПО (ВТ_КолвоПродаж.РегистраторКлиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СуммаПродаж КАК ВТ_СуммаПродаж
	                      |		ПО (ВТ_СуммаПродаж.РегистраторКлиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Заявки КАК ВТ_Заявки
	                      |		ПО (ВТ_Заявки.Клиент = СправочникКлиенты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СуммаЗаявок КАК ВТ_СуммаЗаявок
	                      |		ПО (ВТ_СуммаЗаявок.Клиент = СправочникКлиенты.Ссылка)";
КонецПроцедуры


&НаКлиенте
Процедура СоздатьПродажу(Команда)
	// Вставить содержимое обработчика.
	// ++ obrv 22.01.18
	//Док = СоздатьДок(Элементы.Список.ТекущаяСтрока.Код);
	Док = СоздатьДок(Элементы.Список.ТекущиеДанные.Код);
	// -- obrv 22.01.18
	Док.ПолучитьФорму().ОткрытьМодально();;
КонецПроцедуры

&НаСервере
Функция СоздатьДок(Код)
	Док = Документы.ПродажаЗапчастей.СоздатьДокумент();
	Док.Клиент = Справочники.Клиенты.НайтиПоКоду(Код);
	Док.Дата = ТекущаяДата();
	Док.КтоПродал = НайтиПользователя();
	Док.Записать();
	Возврат Док.Ссылка;
КонецФункции

&НаКлиенте
Процедура СоздатьДозвон(Команда)

	///+ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	КоличесвтоЗаписейВМассиве = ПолучитьКоличествоДозвоновЗаТекущийГод(ТекущиеДанные);
	
	Если КоличесвтоЗаписейВМассиве > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
		
		ПоказатьВопрос(Оповещение, "Дозвон с этим номером телефона в текущем году уже существует! Создать новый?", РежимДиалогаВопрос.ДаНет);
	Иначе
	///-ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)
	
	// ++ obrv 22.01.18
	//Док = СоздатьДок(Элементы.Список.ТекущаяСтрока.Код);
	Док = СоздатьДокДозвон(Элементы.Список.ТекущиеДанные.Код);
	// -- obrv 22.01.18
	ПараметрыФормы = Новый Структура("Ключ", Док);
    ОткрытьФорму("Документ.Дозвон.ФормаОбъекта", ПараметрыФормы);
	//Док.ПолучитьФорму().ОткрытьМодально();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	///+ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)
	Если Результат = КодВозвратаДиалога.Да Тогда
		Док = СоздатьДокДозвон(Элементы.Список.ТекущиеДанные.Код);
		ПараметрыФормы = Новый Структура("Ключ", Док);
		ОткрытьФорму("Документ.Дозвон.ФормаОбъекта", ПараметрыФормы);
	Иначе
		Возврат;
	КонецЕсли;
	///-ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)

КонецПроцедуры

&НаСервере
Функция СоздатьДокДозвон(Код)
	Док = Документы.Дозвон.СоздатьДокумент();
	Док.Клиент = Справочники.Клиенты.НайтиПоКоду(Код);
	Док.Дата = ТекущаяДата();
	Док.Телефон = Док.Клиент.Телефон;
	Док.Автор = НайтиПользователя();
	Док.Статус = Перечисления.СтатусыДозвона.Ожидание;
	ТаблицаДляСкрипта = ПолучитьСкрипт();
	пока  ТаблицаДляСкрипта.следующий() Цикл
	док.Скрипт.Добавить().Описание = ТаблицаДляСкрипта.Описание;
	КонецЦикла;
	Док.Записать();
	Возврат Док.Ссылка;
КонецФункции

Функция  ПолучитьСкрипт()
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЧекЛистЧекЛист.Описание КАК Описание
	               |ИЗ
	               |	Документ.ЧекЛист.ЧекЛист КАК ЧекЛистЧекЛист
	               |ГДЕ
	               |	ЧекЛистЧекЛист.Ссылка = &Чеклист";
	Запрос.УстановитьПараметр("Чеклист", Константы.БЗДляДозвона.Получить());
	Выборка = запрос.Выполнить().Выбрать();

	Возврат Выборка;
	
КонецФункции

&НаСервере
Функция ПолучитьКоличествоДозвоновЗаТекущийГод(ТекущиеДанные)
	
	///+ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Дозвон.Дата КАК Дата,
		|	Дозвон.Телефон КАК Телефон,
		|	Дозвон.Клиент КАК Клиент
		|ИЗ
		|	Документ.Дозвон КАК Дозвон";
	
	СписокДозвонов = Запрос.Выполнить().Выбрать();
	
	МассивДозвоновЗаТекущийГод = Новый Массив;
	Пока СписокДозвонов.Следующий() Цикл
		Если ТекущиеДанные.Телефон = СписокДозвонов.Телефон И Год(ТекущаяДатаСеанса()) = Год(СписокДозвонов.Дата) Тогда
			МассивДозвоновЗаТекущийГод.Добавить(СписокДозвонов);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивДозвоновЗаТекущийГод.Количество();
	///-ГомзМА 13.02.2023 (Задача 000002713 от 13.02.2023)
	
КонецФункции


&НаСервере
Функция НайтиПользователя()
	// ++ obrv 16.01.18
	//Возврат Справочники.Пользователи.НайтиПоНаименованию(ИмяПользователя());
	Возврат ПользователиКлиентСервер.ТекущийПользователь();
	// -- obrv 16.01.18
КонецФункции

&НаКлиенте
Процедура ПокупкиКлиента(Команда)
	// Вставить содержимое обработчика.
	ф = ПолучитьФорму("Обработка.ПокупкиКлиентов.Форма.Форма");
	// ++ obrv 22.01.18
	//ф.Клиент2 =  КлиентЭл(Элементы.Список.ТекущаяСтрока.Код);
	ф.Клиент2 =  КлиентЭл(Элементы.Список.ТекущиеДанные.Код);
	// -- obrv 22.01.18
	ф.откК2 = Истина;
	ф.ОткрытьМодально();
КонецПроцедуры

&НаСервере
Функция КлиентЭл(Код)
	Возврат Справочники.Клиенты.НайтиПоКоду(Код);
КонецФункции

&НаСервере
Функция ПокупкиКлентов()
	ф = Обработки.ПокупкиКлиентов.Создать().ПолучитьФорму();
	// ++ obrv 22.01.18
	//ф.Клиент =  КлиентЭл(Элементы.Список.ТекущаяСтрока.Код);
	ф.Клиент =  КлиентЭл(Элементы.Список.ТекущиеДанные.Код);
	// -- obrv 22.01.18
	ф.ОткрытьМодально();

	Возврат 1;
КонецФункции

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	//ИтогиНаСервере();
КонецПроцедуры


&НаСервере
Процедура ИтогиНаСервере()
	Список.Параметры.УстановитьЗначениеПараметра("ТД", 	ТекущаяДата());
	Список.Параметры.УстановитьЗначениеПараметра("ОбщийКлиент", 	Справочники.Пользователи.НайтиПоНаименованию("Общий Клиент"));
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	//Получаем настройки пользователя (отборы, сортировки и т.п.)
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	//Выводим динамический список в таблицу значений
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Попытка
		КоличествоКлиентов = Результат.Количество();
	Исключение
	КонецПопытки;
	
	Попытка
		Заявки  	= Результат.Итог("КолвоЗаявок");
	Исключение
	КонецПопытки;

	Попытка
		Продажи 	= Результат.Итог("КолвоПродаж");
	Исключение
	КонецПопытки;

	Попытка
		СуммаПродаж = Результат.Итог("СуммаПродаж");
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
///+ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	Если Элементы.Период.Видимость Тогда
	    Список.Параметры.УстановитьЗначениеПараметра("ТД", 	ТекущаяДата());
		Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", 		Период.ДатаНачала);
		Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", 	Период.ДатаОкончания);
		Список.Параметры.УстановитьЗначениеПараметра("ОбщийКлиент", 	Справочники.Пользователи.НайтиПоНаименованию("Общий Клиент"));
		
	КонецЕсли;
	///-ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)	
	
	///+ГомзМА 02.10.2023
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата",  '00010101');
	Список.Параметры.УстановитьЗначениеПараметра("ОбщийКлиент", 	Справочники.Пользователи.НайтиПоНаименованию("Общий Клиент"));
	
	///-ГомзМА 02.10.2023
	ИтогиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПоказатели(Команда)
		ИтогиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	
	Если Фильтр = "1" Тогда
		ОтборСписка = Новый Массив();
		ОтборСписка.Добавить(Истина);
		ОтборСписка.Добавить(Ложь);	
	ИначеЕсли Фильтр = "2" Тогда
		ОтборСписка = Истина;
	ИначеЕсли Фильтр = "3" Тогда
		ОтборСписка = ложь;
	КонецЕсли;
	
	Если Фильтр <> "1" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Целевой", 
		ОтборСписка, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Целевой", 
		ОтборСписка, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	///+ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", 		Период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", 	Период.ДатаОкончания);
	Список.Параметры.УстановитьЗначениеПараметра("ОбщийКлиент", 	ПолучитьОбщегоКлиента());
	
	///-ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	
КонецПроцедуры
Функция ПолучитьОбщегоКлиента()
	Возврат Справочники.Пользователи.НайтиПоНаименованию("Общий Клиент");
КонецФункции
&НаКлиенте
Процедура ЗадатьПериод(Команда)
	
	///+ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	Элементы.ЗадатьПериод.Видимость 	= Не Элементы.ЗадатьПериод.Видимость;
	Элементы.ОтменитьПериод.Видимость 	= Не Элементы.ОтменитьПериод.Видимость;
	Элементы.Период.Видимость 			= Не Элементы.Период.Видимость;
	///-ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПериод(Команда)
	
	///+ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	Элементы.ЗадатьПериод.Видимость 	= Не Элементы.ЗадатьПериод.Видимость;
	Элементы.ОтменитьПериод.Видимость	= Не Элементы.ОтменитьПериод.Видимость;
	Элементы.Период.Видимость 			= Не Элементы.Период.Видимость;
	
	Список.Параметры.Элементы.Найти("ДатаНачала").Использование 	= Ложь;
	Список.Параметры.Элементы.Найти("ДатаОкончания").Использование 	= Ложь;
	///-ГомзМА 16.02.2023 (Задача 000002739 от 16.02.2023)
	
КонецПроцедуры






					  
