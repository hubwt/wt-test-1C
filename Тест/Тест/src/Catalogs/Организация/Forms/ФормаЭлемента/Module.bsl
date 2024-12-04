&НаКлиенте
// Имя картинки, которую пользователь выбирает. Например "Логотип", "ПодписьРуководителя" или "ПодписьБухгалтера".
Перем ВыбираемаяКартинка;



#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
 	Если ИмяСобытия = "Запись_Файл"
		И Параметр.ВладелецФайла = Объект.Ссылка Тогда
		
		Модифицированность = Истина;
		Если ЗначениеЗаполнено(ВыбираемаяКартинка) Тогда
			
			ФайлКартинки = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
			УстановитьКартинкуВЭлементе(ФайлКартинки, ВыбираемаяКартинка);
			ВыбираемаяКартинка = Неопределено;
			
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	МожноРедактироватьФайлы = ПравоДоступа("Редактирование", Метаданные.Справочники.ОрганизацияПрисоединенныеФайлы);
	
	
	МассивИменКартинок = Новый Массив;
	//МассивИменКартинок.Добавить("Логотип");
	МассивИменКартинок.Добавить("Печать");
	//МассивИменКартинок.Добавить("ПодписьРуководителя");
	МассивИменКартинок.Добавить("ПодписьГлавногоБухгалтера");
	//МассивИменКартинок.Добавить("ФаксимильнаяПечать");
	
	МассивИменЭлементов = Новый Массив;
	МассивИменЭлементов.Добавить("ЗагрузитьОчистить");
	МассивИменЭлементов.Добавить("ЗагрузитьКартинку");
	МассивИменЭлементов.Добавить("ВыбратьИзПрисоединенныхФайлов");
	МассивИменЭлементов.Добавить("Очистить");
	
	Для Каждого ИмяКартинки Из МассивИменКартинок Цикл
		ИмяФайла          = "Файл" + ИмяКартинки;
		ИмяАдресаКартинки = "Адрес" + ИмяКартинки;
		
		ТекущийФайл = Объект[ИмяФайла];
		Если НЕ ТекущийФайл.Пустая() Тогда
			Попытка
				ЭтотОбъект[ИмяАдресаКартинки] = ПрисоединенныеФайлы.ПолучитьДанныеФайла(ТекущийФайл, УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла;
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Организация'"), УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.Организации, Объект.Ссылка,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка получения картинки для ""%1"". Подробности в журнале регистрации.'"),
						ЗаголовокРеквизитаКартинки(ИмяАдресаКартинки)),
					Объект.Ссылка);
				Элементы[ИмяАдресаКартинки].ТекстНевыбраннойКартинки = НСтр("ru = 'Ошибка получения файла'");
			КонецПопытки;
		Конецесли;
		Для Каждого ИмяЭлемента Из МассивИменЭлементов Цикл
			Элементы[ИмяЭлемента + ИмяКартинки].Доступность = МожноРедактироватьФайлы;
		КонецЦикла;
	КонецЦикла;
	
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	ЭтоНовый = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
	// Эти поля не нужны. Ответственных указываем в соответствующем справочнике
	Элементы.ФИО.Видимость = Ложь;
	Элементы.РуководительОснование.Видимость = Ложь;
	Элементы.РуководительДолжность.Видимость = Ложь;
	
	Элементы.СтавкиНалогаНаПрибыль.Видимость = Объект.ЕстьНалогНаПрибыль;
	
	
	// Группа Подписи
	//ПодписиУстановитьЗаголовок(Форма);
	
	// Группа Логотип и подпись
	ИменаКартинок = Новый Структура;
	//ИменаКартинок.Вставить("Логотип",                   НСтр("ru='логотип'"));
	ИменаКартинок.Вставить("Печать",                    НСтр("ru='печать'"));
	//ИменаКартинок.Вставить("ПодписьРуководителя",       НСтр("ru='подпись'"));
	//ИменаКартинок.Вставить("ПодписьГлавногоБухгалтера", НСтр("ru='подпись'"));
	//ИменаКартинок.Вставить("ФаксимильнаяПечать",        НСтр("ru='факсимильную печать и подпись'"));
	Для Каждого КлючИЗначение Из ИменаКартинок Цикл
		ИмяФайла       = "Файл" + КлючИЗначение.Ключ;
		ЭлементФормы   = "ЗагрузитьОчистить" + КлючИЗначение.Ключ;
		ОбъектДействия = КлючИЗначение.Значение;
		Если Объект[ИмяФайла].Пустая() Тогда
			Форма[ЭлементФормы] = СтрШаблон(НСтр("ru='Загрузить %1'"), ОбъектДействия); // Например, "Загрузить логотип"
		Иначе
			Форма[ЭлементФормы] = СтрШаблон(НСтр("ru='Очистить %1'"),  ОбъектДействия); // Например, "Очистить логотип"
		Конецесли;
	КонецЦикла;
	
	//Элементы.ДекорацияПредупреждениеФорматФаксимиле.Видимость = Ложь;
		//ЗначениеЗаполнено(Объект.ФайлФаксимильнаяПечать)
		//И 
		//НЕ (ЗначениеЗаполнено(Объект.ФайлПечать)); 
		//ИЛИ ЗначениеЗаполнено(Объект.ФайлПодписьРуководителя)
		//ИЛИ ЗначениеЗаполнено(Объект.ФайлПодписьГлавногоБухгалтера));
	
	
	// Группа подписи
	//Элементы.Руководитель.ТолькоПросмотр = Форма.ТолькоПросмотр;
	//Элементы.РуководительДолжность.ТолькоПросмотр = Форма.ТолькоПросмотр;
	//Элементы.ГлавныйБухгалтер.ТолькоПросмотр = Форма.ТолькоПросмотр;
	//Элементы.ГлавныйБухгалтерДолжность.ТолькоПросмотр = Форма.ТолькоПросмотр;
	//Элементы.Кассир.ТолькоПросмотр = Форма.ТолькоПросмотр;
	//Элементы.КассирДолжность.ТолькоПросмотр = Форма.ТолькоПросмотр;
	
КонецПроцедуры




#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕстьНалогНаПрибыльПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтавкиНалогаНаПрибыль(Команда)
	ОткрытьФорму("РегистрСведений.СтавкиНалогаНаПрибыль.Форма.ФормаСписка",, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
КонецПроцедуры




#КонецОбласти

#Область Печать
&НаКлиенте
Процедура ВыбратьИзПрисоединенныхФайловПечать(Команда)
	
	ВыбратьКартинкуИзПрисоединенныхФайлов("Печать");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзПрисоединенныхФайловПодписьГлавногоБухгалтера(Команда)
	
	ВыбратьКартинкуИзПрисоединенныхФайлов("ПодписьГлавногоБухгалтера");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзПрисоединенныхФайловПодписьРуководителя(Команда)
	
	ВыбратьКартинкуИзПрисоединенныхФайлов("ПодписьРуководителя");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКартинкуПечать(Команда)
	
	ЗагрузитьКартинку("Печать");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКартинкуПодписьГлавногоБухгалтера(Команда)
	
	ЗагрузитьКартинку("ПодписьГлавногоБухгалтера");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКартинкуПодписьРуководителя(Команда)
	
	ЗагрузитьКартинку("ПодписьРуководителя");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПечать(Команда)
	
	ОчиститьКартинку("Печать");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПодписьГлавногоБухгалтера(Команда)
	
	ОчиститьКартинку("ПодписьГлавногоБухгалтера");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПодписьРуководителя(Команда)
	
	ОчиститьКартинку("ПодписьРуководителя");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКартинку(ИмяЭлементаСКартинкой)
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыбираемаяКартинка = ИмяЭлементаСКартинкой;
	
	Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
		+ "|Все файлы(*.*)|*.*"
		+ "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
		+ "|Формат GIF(*.gif*)|*.gif"
		+ "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
		+ "|Формат PNG(*.png*)|*.png"
		+ "|Формат TIFF(*.tif)|*.tif"
		+ "|Формат icon(*.ico)|*.ico"
		+ "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
	
	ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, УникальныйИдентификатор, Фильтр);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОчиститьПечатьНажатие(Элемент, СтандартнаяОбработка)
	
	ЗагрузитьОчиститьКартинку("Печать", СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьОчиститьПодписьГлавногоБухгалтераНажатие(Элемент, СтандартнаяОбработка)
	
	ЗагрузитьОчиститьКартинку("ПодписьГлавногоБухгалтера", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОчиститьПодписьРуководителяНажатие(Элемент, СтандартнаяОбработка)
	
	ЗагрузитьОчиститьКартинку("ПодписьРуководителя", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОчиститьКартинку(ИмяКартинки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если Объект["Файл" + ИмяКартинки].Пустая() Тогда
		ЗагрузитьКартинку(ИмяКартинки);
	Иначе
		ОчиститьКартинку(ИмяКартинки);
	КонецЕсли;

КонецПроцедуры



&НаКлиенте
Процедура ОчиститьКартинку(ИмяЭлементаСКартинкой)

	Модифицированность = Истина;
	ИмяФайла = "Файл" + ИмяЭлементаСКартинкой;
	ИмяАдресаКартинки = "Адрес" + ИмяЭлементаСКартинкой;
	Объект[ИмяФайла] = Неопределено;
	
	УстановитьКартинкуНаФорме(ЭтотОбъект[ИмяАдресаКартинки], Объект[ИмяФайла]);
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура АдресПечатьНажатие(Элемент, СтандартнаяОбработка)
	ОбработатьНажатиеКартинки(СтандартнаяОбработка, "Печать");
КонецПроцедуры

&НаКлиенте
Процедура АдресПодписьГлавногоБухгалтераНажатие(Элемент, СтандартнаяОбработка)
	ОбработатьНажатиеКартинки(СтандартнаяОбработка, "ПодписьГлавногоБухгалтера");
КонецПроцедуры


&НаКлиенте
Процедура АдресПодписьРуководителяНажатие(Элемент, СтандартнаяОбработка)
	ОбработатьНажатиеКартинки(СтандартнаяОбработка, "ПодписьРуководителя");
КонецПроцедуры


// Процедура отвечает за обработку нажатия на картинки формы (логотип/факсим. печать)
//
&НаКлиенте
Процедура ОбработатьНажатиеКартинки(СтандартнаяОбработка, ИмяЭлементаСКартинкой)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект["Файл"+ИмяЭлементаСКартинкой]) Тогда
		
		ДанныеФайла = ПолучитьДанныеФайла(Объект["Файл"+ИмяЭлементаСКартинкой], УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла);
		
	ИначеЕсли МожноРедактироватьФайлы Тогда
		
		ЗагрузитьКартинку(ИмяЭлементаСКартинкой);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор)
	
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
// Функция возвращает навигационую ссылку файла
//
Функция ПолучитьКартинку(ФайлКартинки, УникальныйИдентификатор)
	
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции // ПолучитьТекущуюВерсиюКАртинки()

&НаКлиенте
// Процедура отвечает за отображение/обновление соответствующей картинки
//
Процедура УстановитьКартинкуНаФорме(АктивныйАдрес, РеквизитОбъекта)
	
	Если ЗначениеЗаполнено(РеквизитОбъекта) Тогда
		АктивныйАдрес = ПолучитьКартинку(РеквизитОбъекта, УникальныйИдентификатор);
	Иначе
		АктивныйАдрес = "";
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьКартинкуВЭлементе(ФайлКартинки, ИмяЭлементаСКартинкой)
	
	Модифицированность = Истина;
	ИмяФайла = "Файл" + ИмяЭлементаСКартинкой;
	ИмяАдресаКартинки = "Адрес" + ИмяЭлементаСКартинкой;
	Объект[ИмяФайла] = ФайлКартинки;
	УстановитьКартинкуНаФорме(ЭтотОбъект[ИмяАдресаКартинки], ФайлКартинки);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов(ИмяЭлементаСКартинкой)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВладелецФайла", Объект.Ссылка);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
		
		ДополнительныеПараметры = Новый Структура("ИмяЭлементаСКартинкой", ИмяЭлементаСКартинкой);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКартинкуИзПрисоединенныхФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		//ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы", ПараметрыФормы, Элементы["Адрес"+ИмяЭлементаСКартинкой], , , , ОписаниеОповещения);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, Элементы["Адрес"+ИмяЭлементаСКартинкой],,,, ОписаниеОповещения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайловЗавершение(ВыбраннаяКартинка, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбраннаяКартинка) Тогда
		
		УстановитьКартинкуВЭлементе(ВыбраннаяКартинка, ДополнительныеПараметры.ИмяЭлементаСКартинкой);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаголовокРеквизитаКартинки(ИмяЭлементаСКартинкой)
	ЭлементКартинки = Элементы[ИмяЭлементаСКартинкой];
	Если ЗначениеЗаполнено(ЭлементКартинки.Заголовок) Тогда
		Возврат ЭлементКартинки.Заголовок;
	КонецЕсли;
	
	ПутьКДанным = ЭлементКартинки.ПутьКДанным;
	Реквизиты = ПолучитьРеквизиты();
	Для Каждого Реквизит Из Реквизиты Цикл
		Если Реквизит.Имя = ПутьКДанным Тогда
			Если ЗначениеЗаполнено(Реквизит.Заголовок) Тогда
				Возврат СокрЛП(Реквизит.Заголовок);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИмяЭлементаСКартинкой;
КонецФункции

//&НаКлиенте
//Процедура НалогПриИзменении(Элемент)
//	НалогПриИзмененииНаСервере();
//КонецПроцедуры
//
//&НаСервере
//Процедура НалогПриИзмененииНаСервере()
//	 	
//	 	Запрос = Новый Запрос;
//	 	Запрос.Текст =
//	 		"ВЫБРАТЬ
//	 		|	НДССрезПоследних.Период КАК Период,
//	 		|	НДССрезПоследних.НДС КАК НДС
//	 		|ИЗ
//	 		|	РегистрСведений.НДС.СрезПоследних(, ДокРег = &ДокРег) КАК НДССрезПоследних";
//	 	
//	 	Запрос.УстановитьПараметр("ДокРег", Объект.Ссылка);
//	 	
//	 	РезультатЗапроса = Запрос.Выполнить();
//	 	
//	 	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	 	Период 	= Дата (1,1,1); 
////		НДС     = 0; 
//	 	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//	 		
//	 		Период 	=	ВыборкаДетальныеЗаписи.Период;
////	 		НДС     = 	ВыборкаДетальныеЗаписи.НДС; 
//	 	
//	 	КонецЦикла;
//	 	
//	 	Если (Формат(Период,"ДДД.ММ.ГГГГ") <> Формат(ТекущаяДата(),"ДДД.ММ.ГГГГ"))   Тогда
//	 		
//	 			
//	 		
//	 		
//	 	КонецЕсли; 
//	 	
//		МенеджерЗаписи = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи(); 
//		МенеджерЗаписи.Объект 	= ПолеВводаНоменклатура; 
//		МенеджерЗаписи.Свойство = ПолеВводаСвойствоНоменклатуры; 
//		МенеджерЗаписи.Значение = ПолеВводаЗначениеСвойства; 
//		МенеджерЗаписи.Записать();  
//	
//	
//КонецПроцедуры




#КонецОбласти

#Область СлужебныеПроцедурыИФункции





#КонецОбласти