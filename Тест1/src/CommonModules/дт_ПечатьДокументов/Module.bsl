Функция ПолучитьДанныеДоговораДляПечати(СсылкаНаОбъект) Экспорт
	
	ФорматСуммы = "ЧДЦ=2; ЧГ=3,0";
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	//ЕстьПолеПодписант = ОбщегоНазначения.ЕстьРеквизитОбъекта("Руководитель", МетаданныеОбъекта);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
//	Если ЕстьПолеПодписант Тогда
//		ОтветственныеЛицаСервер.дт_СформироватьВременнуюТаблицуОтветственныхЛицДокументов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СсылкаНаОбъект), Запрос.МенеджерВременныхТаблиц);
//	КонецЕсли;	
	
	Запрос.Текст = 
	СтрШаблон("ВЫБРАТЬ
	|	ЕСТЬNULL(Док.ДоговорКонтрагента.НомерДоговора, """") КАК НомерДоговора,
	|	ЕСТЬNULL(Док.ДоговорКонтрагента.ДатаДоговора, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаДоговора,
	|	&ВалютаРегл КАК ВалютаДоговора,
	|	Док.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	Док.ДоговорКонтрагента.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	Док.ДоговорКонтрагента.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	Док.ДоговорКонтрагента.ОтсрочкаПлатежаВДнях КАК ОтсрочкаПлатежаВДнях,
	|	Док.КтоПродал КАК КтоПродал,
	|	Док.Клиент.ПолноеНаименование КАК ПокупательНаименование,
	|	Док.Организация КАК Организация,
	|	Док.Организация.ПолноеНаименование КАК ОрганизацияНаименование,
	|	Док.Организация.ИНН КАК ОрганизацияИНН,
	|	Док.Организация.КПП КАК ОрганизацияКПП,
	|	Док.Организация.ОГРН КАК ОрганизацияОГРН,
	|	Док.Организация.КодПоОКПО КАК ОрганизацияОКПО,
	|	Док.Организация.ОсновнойБанковскийСчет КАК ОрганизацияБанковскийСчет,
	|	Док.Организация.EMail КАК ОрганизацияEmail,
	|	Док.Организация.Телефон КАК ОрганизацияТелефон,
	|	Док.Организация.ЕстьУчетНДС КАК ЕстьУчетНДС,
	|	Док.Клиент.ИНН КАК ПокупательИНН,
	|	Док.Клиент.Паспорт КАК ПокупательПаспортНомер,
	|	Док.Клиент.ПаспортВыданКем КАК ПокупательПаспортВыданКем,
	|	Док.Клиент.ПаспортВыданДата КАК ПокупательПаспортВыданДата,
	|	Док.Клиент.КПП КАК ПокупательКПП,
	|	Док.Клиент.КодПоОКПО КАК ПокупательОКПО,
	|	Док.Клиент.ЮридическийАдрес КАК ПокупательАдрес,
	|	Док.Клиент.ОГРН КАК ПокупательОГРН,
	|	Док.Клиент.Email КАК ПокупательEmail,
	|	Док.Клиент.Телефон КАК ПокупательТелефон,
	|	БанковскиеСчета.Ссылка КАК ПокупательБанковскийСчет, 
	|	"""" КАК Руководитель,
	|	"""" КАК РуководительФИО,
	|	"""" КАК РуководительДолжность,
	|	"""" КАК РуководительОснование,
	|	Док.Клиент.ФИО КАК ПокупательФИО,
	|	Док.Организация.Адрес КАК ОрганизацияАдрес,
	|	Док.Клиент.ТипКлиента КАК ТипКлиента
	|ИЗ
	|	Документ.%1 КАК Док
	//| Документ.ПродажаЗапчастей  КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ПО Док.Клиент = БанковскиеСчета.Владелец
	|ГДЕ
	|	Док.Ссылка = &Ссылка", МетаданныеОбъекта.Имя);
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("ВалютаРегл", дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	ДанныеОбъекта = Новый Структура;
	
	Если ТаблицаРезультат.Количество() = 0 Тогда
		Возврат ДанныеОбъекта;
	КонецЕсли;
		
		
	ДанныеОбъекта = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРезультат[0]);
	
	// Подписант всегда только основной - руководитель
	ДанныеОтветственногоЛица = ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(ДанныеОбъекта.Организация, ДанныеОбъекта.ДатаДоговора);
	Если ЗначениеЗаполнено(ДанныеОтветственногоЛица.ФизическоеЛицо) Тогда
		
		ДанныеОбъекта.Вставить("РуководительФИО", ДанныеОтветственногоЛица.ФизическоеЛицо);
		ДанныеОбъекта.Вставить("РуководительДолжность", ДанныеОтветственногоЛица.Должность);
		ДанныеОбъекта.Вставить("РуководительОснование", 
			?(ЗначениеЗаполнено(ДанныеОтветственногоЛица.ОснованиеПраваПодписи), 
				ДанныеОтветственногоЛица.ОснованиеПраваПодписи, 
				"Устав"
			)
		);
			
	КонецЕсли;
	
	
//	Руководитель = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьОсновноеОтветственноеЛицоОрганизации(ДанныеОбъекта.Организация);
//	Если ЗначениеЗаполнено(Руководитель) Тогда
//		
//		СвойстваРуководителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Руководитель, "ОснованиеПраваПодписи,ФизическоеЛицо");
//		
//		ДанныеОбъекта.Вставить("РуководительФИО", СвойстваРуководителя.ФизическоеЛицо);
//		ДанныеОбъекта.Вставить("РуководительОснование", 
//			?(ЗначениеЗаполнено(СвойстваРуководителя.ОснованиеПраваПодписи), 
//				СвойстваРуководителя.ОснованиеПраваПодписи, 
//				"Устав"
//			)
//		);
//			
//		// кадровые данные
//		КадровыеДанные = дт_Зарплата.ПолучитьКадровыеДанные(СвойстваРуководителя.ФизическоеЛицо, ДанныеОбъекта.ДатаДоговора);
//		Если КадровыеДанные <> Неопределено Тогда
//			ДанныеОбъекта.Вставить("РуководительДолжность", КадровыеДанные.Должность);	
//		КонецЕсли;
//
//	КонецЕсли;
	
	// Получим полное наименование и сокращенное
	ПолучитьПолноеИСокращенноеНаименование(ДанныеОбъекта, "Покупатель");
	ПолучитьПолноеИСокращенноеНаименование(ДанныеОбъекта, "Организация");
	
	
	// Фаамилии инициалы
	ДанныеОбъекта.Вставить("РуководительФамилияИО", ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ДанныеОбъекта.РуководительФИО));
	ДанныеОбъекта.Вставить("ПокупательФамилияИО", ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ДанныеОбъекта.ПокупательФИО));
	
	///+ГомзМА 24.01.2024
	// Номер телефона менеджера и покупателя
	НомерТелефона = ПолучитьНомерТелефонаМенеджера(ДанныеОбъекта.КтоПродал);
	ДанныеОбъекта.Вставить("НомерТелефонаМенеджера", НомерТелефона);
	ДанныеОбъекта.Вставить("НомерТелефонаПокупателя", ДанныеОбъекта.ПокупательТелефон);
	
	ДатаДействияСтоимости = Формат(НачалоДня(ТекущаяДатаСеанса()) + 86400 * 3, "ДФ=dd.MM.yyyy");
	ДанныеОбъекта.Вставить("ДатаДействияСтоимости", ДатаДействияСтоимости);
	///-ГомзМА 24.01.2024
	
	// Товары и сумма
	ДанныеОбъекта.Вставить("СуммаДоговора", 0);
	ДанныеОбъекта.Вставить("СуммаНДС", 0);
	ДанныеОбъекта.Вставить("СуммаДоговораПрописью", "");
	ДанныеОбъекта.Вставить("СуммаПредоплата", 0);
	ДанныеОбъекта.Вставить("СуммаПредоплатаПрописью", "");
	ДанныеОбъекта.Вставить("СуммаОстаток", 0);
	ДанныеОбъекта.Вставить("СуммаОстатокПрописью", "");
	ДанныеОбъекта.Вставить("НоменклатураНаименование", "");
	ДанныеОбъекта.Вставить("ТекстНДС", "без НДС");
	
	Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ПродажаЗапчастей") 
		ИЛИ ТипЗнч(СсылкаНаОбъект) = тип("ДокументСсылка.ПредварительныйСчет") Тогда
		
		МетаданныеОбъекта = СсылкаНаОбъект.Метаданные(); 
		
		ДопУсловие = "";
		Если дт_ОбщегоНазначения.ЕстьРеквизитТабличнойЧастиОбъекта("Отменено", "Таблица", МетаданныеОбъекта) Тогда
			ДопУсловие = " И НЕ Док.Отменено";
		КонецЕсли;
		
		Запрос.Текст = 
		СтрШаблон(
		"ВЫБРАТЬ
		|	МИНИМУМ(Док.НомерСтроки) КАК НомерСтроки,
		|	СУММА(Док.Сумма) КАК Сумма,
		|	ВЫБОР
		|		КОГДА НЕ Док.Товар.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА ВЫРАЗИТЬ(Док.Товар.НаименованиеПолное КАК СТРОКА(200))
		|		ИНАЧЕ Док.Товар.Наименование
		|	КОНЕЦ КАК НоменклатураНаименование,
		|	Док.Товар.Артикул КАК ТоварАртикул,
		|	Док.Товар.Состояние КАК Состояние,
		|	Док.Цена КАК Цена,
		|	СУММА(Док.Количество) КАК Количество,
		|	"""" КАК СуммаПрописью,
		|	Док.машина.ВинКод КАК ВинКод,
		|	Док.машина.Модель КАК Модель,
		|	Док.машина.Год КАК ГодВыпуска
		|ИЗ
		|	Документ.%1.Таблица КАК Док
		|ГДЕ
		|	Док.Ссылка = &Ссылка %2
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА НЕ Док.Товар.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА ВЫРАЗИТЬ(Док.Товар.НаименованиеПолное КАК СТРОКА(200))
		|		ИНАЧЕ Док.Товар.Наименование
		|	КОНЕЦ,
		|	Док.Товар,
		|	Док.Цена,
		|	Док.Товар.Артикул,
		|	Док.Товар.Состояние,
		|	Док.машина.ВинКод,
		|	Док.машина.Год,
		|	Док.машина.Модель
		|УПОРЯДОЧИТЬ ПО
		| НомерСтроки", МетаданныеОбъекта.Имя, ДопУсловие);
		
		РезультатЗапроса = Запрос.Выполнить();
		Строки = РезультатЗапроса.Выгрузить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ДанныеОбъекта.СуммаДоговора = ДанныеОбъекта.СуммаДоговора + ВыборкаДетальныеЗаписи.Сумма;
			ДанныеОбъекта.НоменклатураНаименование = ДанныеОбъекта.НоменклатураНаименование 
				+ ?(ПустаяСтрока(ДанныеОбъекта.НоменклатураНаименование), "", ", ") 
				+ ВыборкаДетальныеЗаписи.НоменклатураНаименование;
				
		КонецЦикла;
	

		
		// Предоплата по умолчанию 50%
		ДанныеОбъекта.СуммаПредоплата = Окр(ДанныеОбъекта.СуммаДоговора / 2, 2);
		ДанныеОбъекта.СуммаОстаток = ДанныеОбъекта.СуммаДоговора - ДанныеОбъекта.СуммаПредоплата;
		
		ДанныеОбъекта.СуммаПредоплатаПрописью =  РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеОбъекта.СуммаПредоплата, ДанныеОбъекта.ВалютаДоговора);
		ДанныеОбъекта.СуммаОстатокПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеОбъекта.СуммаОстаток, ДанныеОбъекта.ВалютаДоговора);
		
		Строки = ОбщегоНазначения.ТаблицаЗначенийВМассив(Строки);
		НомерСтроки = 1;
		Для каждого СтрокаТаблицы Из Строки Цикл
		
			СтрокаТаблицы.Цена = Формат(СтрокаТаблицы.Цена, ФорматСуммы);
			СтрокаТаблицы.Сумма = Формат(СтрокаТаблицы.Сумма, ФорматСуммы);
			СтрокаТаблицы.НомерСтроки = НомерСтроки;
			НомерСтроки = НомерСтроки + 1;
			
			///+ГомзМА 25.01.2024
			СтрокаТаблицы.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Число(СтрокаТаблицы.Сумма), ДанныеОбъекта.ВалютаДоговора);
		
			///-ГомзМА 25.01.2024
					
		КонецЦикла;
		ДанныеОбъекта.Вставить("Строки", Строки);
		ДанныеОбъекта.Вставить("КоличествоСтрок", Строки.Количество());
		ДанныеОбъекта.Вставить("Модель", Строки[0].Модель);
		ДанныеОбъекта.Вставить("ГодВыпуска", Строки[0].ГодВыпуска);
		ДанныеОбъекта.Вставить("ВинКод", Строки[0].ВинКод);
		
	ИначеЕсли ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ЗаказНаДоставку") Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаДоставку.ДатаНачала КАК ДатаНачалаВыполнения,
		|	ЗаказНаДоставку.ДатаОкончания КАК ДатаОкончанияВыполнения,
		|	ЗаказНаДоставку.МассаГруза КАК МассаГруза,
		|	ЗаказНаДоставку.Груз КАК НоменклатураНаименование,
		|	ЗаказНаДоставку.ПунктОтправления КАК ПунктОтправленияГород,
		|	ЗаказНаДоставку.ПунктНазначения КАК ПунктНазначенияГород,
		|	ЗаказНаДоставку.ПунктОтправленияАдрес КАК ПунктОтправленияАдрес,
		|	ЗаказНаДоставку.ПунктНазначенияАдрес КАК ПунктНазначенияАдрес,
		|	ВЫБОР
		|		КОГДА ЗаказНаДоставку.Грузоотправитель = &ПустоКлиент
		|			ТОГДА ЗаказНаДоставку.Клиент
		|		ИНАЧЕ ЗаказНаДоставку.Грузоотправитель
		|	КОНЕЦ КАК Грузоотправитель,
		|	ВЫБОР
		|		КОГДА ЗаказНаДоставку.Грузополучатель = &ПустоКлиент
		|			ТОГДА ЗаказНаДоставку.Клиент
		|		ИНАЧЕ ЗаказНаДоставку.Грузополучатель
		|	КОНЕЦ КАК Грузополучатель,
		|	ЗаказНаДоставку.Дата КАК Дата,
		|	ЗаказНаДоставку.СуммаДокумента КАК СуммаДокумента,
		|	ЗаказНаДоставку.Номер КАК Номер
		|ИЗ
		|	Документ.ЗаказНаДоставку КАК ЗаказНаДоставку
		|ГДЕ
		|	ЗаказНаДоставку.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
		Запрос.УстановитьПараметр("ПустоКлиент", Справочники.Клиенты.ПустаяСсылка());
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		Выборка.Следующий();
		
		ДанныеОбъекта.Вставить("НоменклатураНаименование", Выборка.НоменклатураНаименование);
		ДанныеОбъекта.Вставить("МассаГруза", 				Формат(Выборка.МассаГруза, "ЧН=_____; ЧГ=3,0"));
		ДанныеОбъекта.Вставить("ДатаНачалаВыполнения", 		Выборка.ДатаНачалаВыполнения);
		ДанныеОбъекта.Вставить("ДатаОкончанияВыполнения", 	Выборка.ДатаОкончанияВыполнения);
		ДанныеОбъекта.Вставить("ПунктОтправленияГород", 			Выборка.ПунктОтправленияГород);
		ДанныеОбъекта.Вставить("ПунктНазначенияГород",	 		Выборка.ПунктНазначенияГород);
		
		
		//ГрузополучательНаименование
		СведенияОГрузополучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Выборка.Грузополучатель, Выборка.Дата);
		
		ДанныеОбъекта.Вставить("ГрузополучательНаименование", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "НаименованиеДляПечатныхФорм"));
		
		
		// ПунктНазначения, ПунктОтправления
		ДанныеОбъекта.Вставить("ПунктОтправления", дт_Грузоперевозки.ПолучитьПолныйАдрес(Выборка.ПунктОтправленияГород, Выборка.ПунктОтправленияАдрес));
		ДанныеОбъекта.Вставить("ПунктНазначения", дт_Грузоперевозки.ПолучитьПолныйАдрес(Выборка.ПунктНазначенияГород, Выборка.ПунктНазначенияАдрес));
		
		// ГрузоотправительПредставление - грузоотправитель + адрес отправления
		Если Выборка.Грузоотправитель = Выборка.Грузополучатель Тогда
			СведенияОГрузоотправителе = СведенияОГрузополучателе;
		Иначе	
			СведенияОГрузоотправителе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Выборка.Грузоотправитель, Выборка.Дата);
		КонецЕсли;
		
		АдресОтправления = дт_Грузоперевозки.ПолучитьПолныйАдрес(Выборка.ПунктОтправленияГород, Выборка.ПунктОтправленияАдрес);
		Если ЗначениеЗаполнено(АдресОтправления) Тогда
			ДанныеОбъекта.Вставить("ГрузоотправительПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправителе, "НаименованиеДляПечатныхФорм") + ", " + АдресОтправления);
		Иначе
			ДанныеОбъекта.Вставить("ГрузоотправительПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправителе, "НаименованиеДляПечатныхФорм,ФактическийАдрес"));
		КонецЕсли;
		
		ДанныеОбъекта.СуммаДоговора = Выборка.СуммаДокумента;
		
	Иначе
		
		ДанныеОбъекта.СуммаДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, "СуммаДокумента");
		
	КонецЕсли;
	
	ДанныеОбъекта.СуммаДоговораПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеОбъекта.СуммаДоговора, ДанныеОбъекта.ВалютаДоговора);
	
	Если ДанныеОбъекта.ЕстьУчетНДС Тогда
		СтавкаНДС = дт_ОбщегоНазначенияВызовСервераПовтИсп.СтавкаНДСПоУмолчанию(ДанныеОбъекта.ДатаДоговора);
		ДанныеОбъекта.СуммаНДС = Окр(ДанныеОбъекта.СуммаДоговора * СтавкаНДС / (100  + СтавкаНДС), 2);
		ДанныеОбъекта.ТекстНДС = СтрШаблон("в т.ч. НДС %1 (%2)", 
			ДанныеОбъекта.СуммаНДС,
			РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеОбъекта.СуммаНДС, ДанныеОбъекта.ВалютаДоговора)
		);
	КонецЕсли;
	
	// Преобразования
	Для каждого КлючИЗначение Из ДанныеОбъекта Цикл
	
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Дата") Тогда
			ДанныеОбъекта.Вставить(КлючИЗначение.Ключ + "DD", Формат(КлючИЗначение.Значение, "ДЛФ=DD"));
			ДанныеОбъекта.Вставить(КлючИЗначение.Ключ + "D", Формат(КлючИЗначение.Значение, "ДФ='dd.MM.yyyy ''г.'''"));
		КонецЕсли;
	
	КонецЦикла;
	
	
	
	// Падежи
	СклоняемыеДанные = Новый Массив();
	СклоняемыеДанные.Добавить("РуководительДолжность");
	СклоняемыеДанные.Добавить("РуководительФИО");
	СклоняемыеДанные.Добавить("РуководительОснование");
	СклоняемыеДанные.Добавить("ПокупательФИО");
	
	Для каждого СклоняемыйРеквизит Из СклоняемыеДанные Цикл
		
		Фраза = ДанныеОбъекта[СклоняемыйРеквизит];
		Склонение = ?(СтрНайти(СклоняемыйРеквизит, "ФИО") <> 0,
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 2),
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 2)
		);
		
		ДанныеОбъекта.Вставить(СклоняемыйРеквизит + "_РП", Склонение);
	
	КонецЦикла;
	
	
	
	// Параметры в зависимости от частного лица
	Если ДанныеОбъекта.ТипКлиента = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ИП") Тогда
		
		//ДанныеОбъекта.ПокупательНаименование = СтрШаблон("Индивидуальный предприниматель %1", ДанныеОбъекта.ПокупательФИО);
		
		ДанныеОбъекта.Вставить("ПокупательВЛице", "");
		ДанныеОбъекта.Вставить("ДействующийОкончание", "ий");
		ДанныеОбъекта.Вставить("ИменуемыйОкончание", "ый");
		ДанныеОбъекта.Вставить("ПокупательОснование", "свидетельства о государственной регистрации физического лица в качестве индивидуального предпринимателя");
		
	ИначеЕсли ДанныеОбъекта.ТипКлиента = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ФизЛицо") Тогда
		
		//ДанныеОбъекта.ПокупательНаименование = СтрШаблон(ДанныеОбъекта.ПокупательФИО);
		
		ДанныеОбъекта.Вставить("ПокупательВЛице", "");
		ДанныеОбъекта.Вставить("ДействующийОкончание", "ий");
		ДанныеОбъекта.Вставить("ИменуемыйОкончание", "ый");
		ДанныеОбъекта.Вставить("ПокупательОснование", "");
	Иначе	
		ДанныеОбъекта.Вставить("ПокупательВЛице", ", в лице Директора " + ДанныеОбъекта.ПокупательФИО_РП);
		ДанныеОбъекта.Вставить("ДействующийОкончание", "его");
		ДанныеОбъекта.Вставить("ИменуемыйОкончание", "ое");
		ДанныеОбъекта.Вставить("ПокупательОснование", "Устава");
	КонецЕсли;
	
	
	// Реквизиты банковские
	ДанныеОбъекта.Вставить("ОрганизацияРеквизиты", ПредставлениеРеквизитов(ДанныеОбъекта.ОрганизацияБанковскийСчет));
	ДанныеОбъекта.Вставить("ПокупательРеквизиты", ПредставлениеРеквизитов(ДанныеОбъекта.ПокупательБанковскийСчет));
	ДанныеОбъекта.Вставить("ПокупательПаспорт", "");
	
	// Если банковских реквизитов нет, то паспорт и прописка
	Если ПустаяСтрока(ДанныеОбъекта.ПокупательРеквизиты) Тогда
		Если ОбщегоНазначенияУТКЛиентСервер.ЭтоЧастноеЛицо(ДанныеОбъекта.ТипКлиента) Тогда
			ДанныеОбъекта.ПокупательПаспорт = 
				СтрШаблон("Паспорт: %1 выдан %2 %3",
					ДанныеОбъекта.ПокупательПаспортНомер,
					ДанныеОбъекта.ПокупательПаспортВыданКем,
					ДанныеОбъекта.ПокупательПаспортВыданДатаD
				);
		КонецЕсли;
	КонецЕсли;
	ДанныеОбъекта.Вставить("Поставщик", "Поставщик");
	ДанныеОбъекта.Вставить("Покупатель", "Покупатель");
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Функция ПолучитьНомерТелефонаМенеджера(Менеджер)

	///+ГомзМА 24.01.2024
	Результат = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	СотрудникиКонтактнаяИнформация.Представление КАК Представление,
		|	СотрудникиКонтактнаяИнформация.Представление КАК ТелефонСлужебный
		|ИЗ
		|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
		|ГДЕ
		|	СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаСлужебный)
		|	И СотрудникиКонтактнаяИнформация.Ссылка.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Менеджер);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Если РезультатЗапроса.Количество() > 0 Тогда
		РезультатЗапроса.Следующий();
		Результат = РезультатЗапроса.ТелефонСлужебный;
	КонецЕсли;
	
	Возврат Результат;
	///-ГомзМА 24.01.2024

КонецФункции // ПолучитьНомерТелефонаМенеджера(Менеджер)


Функция ПолучитьДанныеДоверенностиДляПечати(СсылкаНаОбъект) Экспорт
	
	ФорматСуммы = "ЧДЦ=2; ЧГ=3,0";
	
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.Дата КАК Дата,
	|	Док.Организация КАК Организация,
	|	Док.Сотрудник КАК Сотрудник,
	|	Док.Номер КАК Номер,
	|	Док.СрокДействия
	|ИЗ
	|	Документ.Доверенность КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	ДанныеОбъекта = Новый Структура;
	
	Если ТаблицаРезультат.Количество() = 0 Тогда
		Возврат ДанныеОбъекта;
	КонецЕсли;
		
		
	ДанныеОбъекта = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРезультат[0]);
	
	// Подписант всегда только основной - руководитель
	ДанныеОтветственногоЛица = ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(ДанныеОбъекта.Организация, ДанныеОбъекта.Дата);
	Если ЗначениеЗаполнено(ДанныеОтветственногоЛица.ФизическоеЛицо) Тогда
		
		ДанныеОбъекта.Вставить("РуководительФИО", ДанныеОтветственногоЛица.ФизическоеЛицо);
		ДанныеОбъекта.Вставить("РуководительДолжность", ДанныеОтветственногоЛица.Должность);
		ДанныеОбъекта.Вставить("РуководительОснование", 
			?(ЗначениеЗаполнено(ДанныеОтветственногоЛица.ОснованиеПраваПодписи), 
				ДанныеОтветственногоЛица.ОснованиеПраваПодписи, 
				"Устав"
			)
		);
			
		// Фамилии инициалы
		ДанныеОбъекта.Вставить("РуководительФамилияИО", ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ДанныеОбъекта.РуководительФИО));
	КонецЕсли;
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеОбъекта.Организация, ДанныеОбъекта.Дата);
		
	ДанныеОбъекта.Вставить("ОрганизацияНаименование", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм", Ложь));
	ДанныеОбъекта.Вставить("ОрганизацияИНН", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ИНН", Ложь));
	ДанныеОбъекта.Вставить("ОрганизацияEmail", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "Email", Ложь));

	// Получим полное наименование и сокращенное
	ПолучитьПолноеИСокращенноеНаименование(ДанныеОбъекта, "Организация");
	
	СведенияОСотруднике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеОбъекта.Сотрудник, ДанныеОбъекта.Дата); 	
	ДанныеОбъекта.Вставить("СотрудникФИО", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОСотруднике, "НаименованиеДляПечатныхФорм"));
	ДанныеОбъекта.Вставить("СотрудникПаспорт", 				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОСотруднике, "Паспорт"));
	
	
	// Преобразования
	Для каждого КлючИЗначение Из ДанныеОбъекта Цикл
	
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Дата") Тогда
			ДанныеОбъекта.Вставить(КлючИЗначение.Ключ + "DD", Формат(КлючИЗначение.Значение, "ДЛФ=DD"));
			ДанныеОбъекта.Вставить(КлючИЗначение.Ключ + "D", Формат(КлючИЗначение.Значение, "ДФ='dd.MM.yyyy ''г.'''"));
		КонецЕсли;
	
	КонецЦикла;
	
	
	
	// Падежи РП
	СклоняемыеДанные = Новый Массив();
	СклоняемыеДанные.Добавить("РуководительДолжность");
	СклоняемыеДанные.Добавить("РуководительФИО");
	СклоняемыеДанные.Добавить("РуководительОснование");
	
	Для каждого СклоняемыйРеквизит Из СклоняемыеДанные Цикл
		
		Если НЕ ДанныеОбъекта.Свойство(СклоняемыйРеквизит) Тогда
			Продолжить
		КонецЕсли;
		
		Фраза = ДанныеОбъекта[СклоняемыйРеквизит];
		Склонение = ?(СтрНайти(СклоняемыйРеквизит, "ФИО") <> 0,
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 2),
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 2)
		);
		
		ДанныеОбъекта.Вставить(СклоняемыйРеквизит + "_РП", Склонение);
	
	КонецЦикла;
	
	// Падежи ТП
	СклоняемыеДанные = Новый Массив();
	СклоняемыеДанные.Добавить("СотрудникФИО");
	
	Для каждого СклоняемыйРеквизит Из СклоняемыеДанные Цикл
		
		Фраза = ДанныеОбъекта[СклоняемыйРеквизит];
		Склонение = ?(СтрНайти(СклоняемыйРеквизит, "ФИО") <> 0,
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 3),
			СклонениеПредставленийОбъектов.ПросклонятьФИО(Фраза, 3)
		);
		
		ДанныеОбъекта.Вставить(СклоняемыйРеквизит + "_ДП", Склонение);
	
	КонецЦикла;
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Функция ПредставлениеРеквизитов(БанковскийСчет)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БанковскийСчетКонтрагента.НомерСчета КАК НомерСчета,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскийСчетКонтрагента.БИКБанка
	|		ИНАЧЕ КлассификаторБанков.Код
	|	КОНЕЦ КАК БИКБанк,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскийСчетКонтрагента.НаименованиеБанка
	|		ИНАЧЕ КлассификаторБанков.Наименование
	|	КОНЕЦ КАК НаименованиеБанка,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскийСчетКонтрагента.КоррСчетБанка
	|		ИНАЧЕ КлассификаторБанков.КоррСчет
	|	КОНЕЦ КАК КоррСчетБанка,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанка
	|			ТОГДА БанковскийСчетКонтрагента.ГородБанка
	|		ИНАЧЕ КлассификаторБанков.Город
	|	КОНЕЦ КАК ГородБанка,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА БанковскийСчетКонтрагента.БИКБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Код
	|	КОНЕЦ КАК БИКБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА БанковскийСчетКонтрагента.НаименованиеБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Наименование
	|	КОНЕЦ КАК НаименованиеБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА БанковскийСчетКонтрагента.КоррСчетБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.КоррСчет
	|	КОНЕЦ КАК КоррСчетБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА БанковскийСчетКонтрагента.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА БанковскийСчетКонтрагента.ГородБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Город
	|	КОНЕЦ КАК ГородБанкаДляРасчетов
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскийСчетКонтрагента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО БанковскийСчетКонтрагента.Ссылка.Ссылка.Банк = КлассификаторБанков.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанковКорреспондентовРФ
	|		ПО БанковскийСчетКонтрагента.Ссылка.БанкДляРасчетов = КлассификаторБанковКорреспондентовРФ.Ссылка
	|ГДЕ
	|	БанковскийСчетКонтрагента.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", БанковскийСчет);
	
	Результат = "";
	
	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
		Возврат Результат;
	КонецЕсли;
	
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.БИКБанкаДляРасчетов) Тогда
			
			Результат = СтрШаблон(
				"р/с %1 в %2 г.%3" + Символы.ПС + "к/с %4" + Символы.ПС + "БИК %5",
				Выборка.НомерСчета,
				Выборка.НаименованиеБанка,
				Выборка.ГородБанка,
				Выборка.КоррСчетБанка,
				Выборка.БИКБанк
			);
			
		Иначе
			Результат = СтрШаблон(
				"р/с %1 в %2 г.%3" + Символы.ПС + "к/с %4" + Символы.ПС + "БИК %5",
				Выборка.НомерСчета,
				Выборка.НаименованиеБанкаДляРасчетов,
				Выборка.ГородБанкаДляРасчетов,
				Выборка.КоррСчетБанкаДляРасчетов,
				Выборка.БИКБанкаДляРасчетов
			);
		КонецЕсли;
	КонецЦикла;
	
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПолноеИСокращенноеНаименование(ДанныеПечати, ПрефиксСвойства)

	Наименование = ДанныеПечати[ПрефиксСвойства + "Наименование"];
	НаименованиеПолное = Наименование;
	
	ДанныеПечати.Вставить(ПрефиксСвойства + "НаименованиеПолное");
	
	Замены = дт_ОбщегоНазначенияПовтИсп.ПолучитьТаблицуСокращений();
	
	Для каждого Замена Из Замены Цикл
		
		Наименование = СтрЗаменить(Наименование, Замена.Полное, Замена.Сокращенное);
		НаименованиеПолное = СтрЗаменить(НаименованиеПолное, Замена.Сокращенное, Замена.Полное); 
		
		ДанныеПечати[ПрефиксСвойства + "Наименование"] = Наименование;
		ДанныеПечати[ПрефиксСвойства + "НаименованиеПолное"] = НаименованиеПолное;
	
	КонецЦикла; 
		
	
КонецФункции // ПолучитьПолноеИСокращенноеНаименование()



Функция ПолучитьОписаниеОбластейМакетаОфисногоДокумента() Экспорт
	
	ОписаниеОбластей = Новый Структура;
	
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ШапкаДокумента",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ШапкаТаблицы",		"СтрокаТаблицы");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "СтрокаТаблицы",	"СтрокаТаблицы");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ПодвалДокумента",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ВерхнийКолонтитул",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "НижнийКолонтитул",	"Общая");
	
	Возврат ОписаниеОбластей;
	
КонецФункции

Процедура УстановитьМинимальныеПоляПечати(ТабличныйДокумент) Экспорт

	// Проверка на веб-клиент
	СисИнфо = Новый СистемнаяИнформация;
	ЗначениеБоковогоПоля = ?(ПустаяСтрока(СисИнфо.ИнформацияПрограммыПросмотра), 5, 10); 
	
	Если ТабличныйДокумент.ПолеСлева < ЗначениеБоковогоПоля Тогда
		ТабличныйДокумент.ПолеСлева = ЗначениеБоковогоПоля;
	КонецЕсли; 
	
	Если ТабличныйДокумент.ПолеСправа < ЗначениеБоковогоПоля Тогда
		ТабличныйДокумент.ПолеСправа = ЗначениеБоковогоПоля;
	КонецЕсли;
	
	Если ТабличныйДокумент.ПолеСверху < 5 Тогда
		ТабличныйДокумент.ПолеСверху = 5;
	КонецЕсли; 

	Если ТабличныйДокумент.ПолеСнизу < 5 Тогда
		ТабличныйДокумент.ПолеСнизу = 5;
	КонецЕсли;

КонецПроцедуры
