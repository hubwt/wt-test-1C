

#Область ОбработчикиСобытийФормы

	&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///+ГомзМА 11.04.2023 
	Поступления.Параметры.УстановитьЗначениеПараметра	   ("ТМЦ", 		Объект.Ссылка);
	Перемещения.Параметры.УстановитьЗначениеПараметра	   ("ТМЦ", 		Объект.Ссылка);
	Списания.Параметры.УстановитьЗначениеПараметра	 	   ("ТМЦ", 		Объект.Ссылка);
	ИнвентарныеНомера.Параметры.УстановитьЗначениеПараметра("Владелец", Объект.Ссылка);
	Комплектующие.Параметры.УстановитьЗначениеПараметра	   ("ТМЦ", 		Объект.Ссылка); 
	///-ГомзМА 11.04.2023
	
	ОбновитьПанельКартинок();
	
	//Получение аналитики цен ТМЦ
	РезультатЗапроса = РаботаСДокументамиТМЦВызовСервера.ПолучитьАналитикуСтоимости(Объект.Ссылка);
	
	СредняяСтоимость 	  = РезультатЗапроса.СредняяСтоимость;
	СамаяНизкаяСтоимость  = РезультатЗапроса.СамаяНизкаяСтоимость;
	СамаяВысокаяСтоимость = РезультатЗапроса.СамаяВысокаяСтоимость;
	
	ПостроитьГрафикНаСервере();
	
	///+ГомзМА 25.09.2023
	Схема = Элементы.Комплектующие.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Комплектующие.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.КомплектующиеСумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.КомплектующиеСумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");
	///-ГомзМА 25.09.2023
	
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.Код <> ТекущийОбъект.Код Тогда
		ОбновитьПанельКартинок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	ОбновитьПанельКартинок();
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиКомандФормы

	

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

	&НаСервере
Процедура ОбновитьПанельКартинок()
	
	ЭлементыКУдалению = Новый Массив();
	
	Для каждого Элемент Из Элементы.ГруппаКартинки.ПодчиненныеЭлементы Цикл
		
		ЭлементыКУдалению.Добавить(Элемент);
		                                               
	КонецЦикла;
	
	Для Индекс = 0 По ЭлементыКУдалению.Количество() - 1 Цикл
		Элементы.Удалить(ЭлементыКУдалению[Индекс]);
	КонецЦикла;
	
	КаталогКартинок = Константы.дт_КаталогКартинокТМЦ.Получить();
	Если Не ЗначениеЗаполнено(КаталогКартинок) Тогда
		Возврат
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Код) Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ СтрЗаканчиваетсяНа(КаталогКартинок, "\") Тогда
		КаталогКартинок = КаталогКартинок + "\";
	КонецЕслИ;	
	
	КодОбъекта 		= СокрЛП(Объект.Код);
	
	КаталогКартинок = КаталогКартинок + КодОбъекта;
	
	Картинки 		= дт_ФайлыНаДиске.ПолучитьСписокКартинок(КаталогКартинок, КодОбъекта);
	
	ОписанияФайлов 	= Новый Структура();
	
	Для Индекс = 0 По Картинки.Количество() - 1 Цикл
		Файл = Картинки[Индекс];
		ДобавитьКартинку(Файл.ПолноеИмя, Файл.Имя, Индекс);
	КонецЦикла;
	
	
КонецПроцедуры



&НаСервере
Процедура ДобавитьКартинку(ИмяФайла, ИмяСокращенное, Индекс)
	
	СтрокаУИ 			= СтрШаблон("Картинка%1", Индекс);//СтрЗаменить(ИмяСокращенное, ".", "_");
	Элемент 			= Элементы.Добавить(СтрокаУИ, Тип("ДекорацияФормы"), Элементы.ГруппаКартинки);
	Элемент.Вид 		= ВидДекорацииФормы.Надпись;
	Элемент.Гиперссылка = Истина;
	Элемент.Заголовок 	= СтрШаблон("Фото %1", Индекс + 1); //ВыборкаДетальныеЗаписи.Представление;
	Элемент.УстановитьДействие("Нажатие", "ОткрытьКартинку");
	
	ОписанияФайлов.Вставить(Элемент.Имя, Новый Структура("ИмяФайлаСервер", ИмяФайла));
	
КонецПроцедуры



&НаКлиенте
Процедура ОткрытьКартинку(Элемент)
	
	#Если ВебКлиент Тогда
	
	ПоказатьПредупреждение(, "В режиме веб-клиента функция не поддерживается");
		
	#Иначе
	
	Отказ = Ложь;
	
	ОписаниеФайла = ОписанияФайлов[Элемент.Имя];
	ИмяФайла 	  = ОписаниеФайла.ИмяФайлаСервер;
	
	ИмяВрем = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеФайла, "ИмяФайлаЛок", Неопределено);
	 
	Если ИмяВрем = Неопределено Тогда
	
		АдресФайла = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		ПолучитьФайлССервера(АдресФайла, ИмяФайла, Отказ);
	
		Если Отказ Тогда 
			Возврат
		КонецЕсли;
	
		Расширение 	= ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
		ИмяВрем 	= ПолучитьИмяВременногоФайла(Расширение);
		ПолучитьФайл(АдресФайла, ИмяВрем, Ложь);
		ОписаниеФайла.Вставить("ИмяФайлаЛок", ИмяВрем);
			
	КонецЕсли;
		
	
	
	Ф = Новый Файл(ИмяВрем);
	
	Если Ф.Существует() Тогда
		
		ЗапуститьПриложение(ИмяВрем, , Ложь);
		
	КонецЕсли;
	
	#КонецЕсли
		
КонецПроцедуры


&НаСервере
Процедура ПолучитьФайлССервера(Адрес, ИмяФайла, Отказ)
	
	Попытка
		
		ДвДанные = Новый ДвоичныеДанные(ИмяФайла);
		ПоместитьВоВременноеХранилище(ДвДанные, Адрес);
			
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Не удалось получить файл с сервере %1. %2",
				ИмяФайла,
				ОписаниеОшибки()),
			,
			,
			,
			Отказ
		);
		
	КонецПопытки;
		
КонецПроцедуры


&НаСервере
Процедура ПостроитьГрафикНаСервере()

	///+ГомзМА 03.05.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Цена КАК Цена,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Ссылка.Ссылка КАК Ссылка,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.ТМЦ КАК ТМЦ
		|ИЗ
		|	Документ.ПоступлениеТМЦСкладСнабжение.СписокТМЦ КАК ПоступлениеТМЦСкладСнабжениеСписокТМЦ
		|ГДЕ
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.ТМЦ = &ТМЦ
		|	И ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Ссылка.Проведен";
	
	Запрос.УстановитьПараметр("ТМЦ", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	Для каждого СтрокаРезультата Из РезультатЗапроса Цикл
		Серия = ДиаграммаСтоимостей.Серии.Добавить (СтрокаРезультата.Цена);
		
		Точка = ДиаграммаСтоимостей.УстановитьТочку(СтрокаРезультата.Ссылка);
		
		ДиаграммаСтоимостей.УстановитьЗначение(Точка, Серия, СтрокаРезультата.Цена);
	КонецЦикла;
	///-ГомзМА 03.05.2023

	///////////////////////////////////////
	//Серия = Диаграмма.Серии.Добавить("ТМЦ");	
	//	
	//Для Значение = 1 По 10 Цикл
	//
	//	Точка = Диаграмма.УстановитьТочку(Значение);
	//	Диаграмма.УстановитьЗначение(Точка, Серия, Значение);
	//		
	//КонецЦикла;
	////////////////////////////////////////
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектующиеИнвентарныйНомерНажатие(Элемент, СтандартнаяОбработка)
	
	ОткрытьФорму("Справочник.ИнвентарныеНомера.ФормаОбъекта");
	
КонецПроцедуры




#КонецОбласти









