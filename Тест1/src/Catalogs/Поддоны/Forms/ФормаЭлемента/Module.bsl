
&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	Если объект.Наименование <> "" Тогда
		Запрос = новый запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ИндНомер.индкод КАК индкод
		|ИЗ
		|	РегистрСведений.ИндНомер КАК ИндНомер
		|ГДЕ
		|	ИндНомер.поддон = &поддон"; 
		запрос.УстановитьПараметр("поддон", объект.Ссылка);
		выборка = Запрос.Выполнить().Выбрать(); 
		Выборка.Следующий();
		
		
		Пока Выборка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.ИндНомер.СоздатьНаборЗаписей();  			
			НаборЗаписей.Отбор.индкод.Установить(Выборка.индкод);
			НаборЗаписей.Прочитать();
			Для Каждого стрНабора из НаборЗаписей Цикл
				стрНабора.стеллаж = объект.Стеллаж; //5
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЦикла; 
	КонецЕсли;
	
	//РегистрТовара.Записать();//6   
КонецПроцедуры

&НаКлиенте
Процедура СтеллажПриИзменении(Элемент)
	ВладелецПриИзмененииНаСервере();
	Событие = "Сменил стеллаж на: " + Объект.Стеллаж;
	ЗаписьЛога(Событие);
КонецПроцедуры

&НаКлиенте
Процедура СтеллажНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЭтаФорма.Записать();	
КонецПроцедуры   


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	штрихкод = Получитькомпоненту();  
	Элементы.QRКод.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	Список.Параметры.УстановитьЗначениеПараметра("Поддон",объект.Ссылка);
	ВыводЛога();
КонецПроцедуры  
&НаСервере
Функция Получитькомпоненту()
	ТекстОшибки = "";
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(ТекстОшибки); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = объект.Наименование;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	
	QRкод = ПоместитьВоВременноеХранилище(КартинкаШтрихКод,УникальныйИдентификатор);
	возврат истина;
КонецФункции  


Процедура ЗаписьЛога(Событие)
	
	ТекстЛога =  "----------------------------------------------------" + Символы.ПС + ТекущаяДата() + Символы.ПС + Пользователи.ТекущийПользователь() + Символы.ПС +" "+ Событие + Символы.ПС ;
	
	ЗаписьЛога = РегистрыСведений.УниверсальныйЛог.СоздатьМенеджерЗаписи();
	ЗаписьЛога.Объект 		 = Объект.Ссылка;
	ЗаписьЛога.Период 		 = ТекущаяДата();
	ЗаписьЛога.Лог           = ТекстЛога;
	ЗаписьЛога.Записать();
	ВыводЛога();
	//Объект.Лог	=  Объект.Лог+ ТекстЛога;
КонецПроцедуры     

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	//ВладелецПриИзмененииНаСервере();
	Событие = "Сменил стеллаж на: " + Объект.Стеллаж;
	ЗаписьЛога(Событие);
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Событие = "Сменил Наименование на: " + Объект.Наименование;
	ЗаписьЛога(Событие);
КонецПроцедуры  


Процедура ВыводЛога()
	НаборЛогов = "";
	Запрос = Новый запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	УниверсальныйЛог.Лог КАК Текст
	|ИЗ
	|	РегистрСведений.УниверсальныйЛог КАК УниверсальныйЛог
	|ГДЕ
	|	УниверсальныйЛог.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	
	Логи = Запрос.Выполнить().Выбрать();
	
	Пока Логи.Следующий() Цикл
		НаборЛогов = НаборЛогов + Логи.Текст;
	КонецЦикла;
	Лог = объект.Лог + НаборЛогов;
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТабДок = ПечатьСервер();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Печать");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "Печать";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	
	//ТабДокумент = ПечатьСервер("Место");
	//ТабДокумент.Показать();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМакет()
	Возврат  Справочники.Поддоны.ПолучитьМакет("Макет");
КонецФункции

&НаСервере
Функция ПечатьСервер(Сортировка = Неопределено)
	ЭтотОбъект.Записать();
	// Вставить содержимое обработчика.
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет();
	ОбластьМакета = Макет.ПолучитьОбласть("шапка");
	//ОбластьМакета.Параметры.заголовок = "Заявка  № "+Объект.Номер+"Р от " + Объект.Дата;
	//ОбластьМакета.Параметры.покупатель = Объект.Клиент;
	ОбластьМакета.Параметры.Поддон = Объект.Наименование;
	ОбластьМакета.Параметры.Дата = ТекущаяДата();
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(""); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = объект.Наименование;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	ФайлКартинки 			             = КартинкаШтрихКод;
	ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаШтрихКод;
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	// ++ obrv 24.07.18
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ИндНомер.индкод КАК индкод,
	|	ИндНомер.индкод.Владелец КАК индкодВладелец,
	|	АВТОНОМЕРЗАПИСИ() КАК Номер
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|ГДЕ
	|	ИндНомер.Поддон = &Поддон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.индкодВладелец КАК индкодВладелец,
	|	ВТ.индкод КАК индкод,
	|	ВТ.Номер КАК Номер
	|ИЗ
	|	ВТ КАК ВТ"; 	
	
	
	Запрос.УстановитьПараметр("Поддон",  Объект.ссылка);
	ОбластьСтроки = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьСтроки);
	
	
	ОбластьСтроки = Макет.ПолучитьОбласть("строкатаблицы");
	//ТабДокумент.Вывести(ОбластьСтроки);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока выборка.Следующий() Цикл
		ОбластьСтроки.Параметры.н = Выборка.Номер;
		ОбластьСтроки.Параметры.товар = Выборка.индкодВладелец;
		ОбластьСтроки.Параметры.индкод = Выборка.индкод;
		ТабДокумент.Вывести(ОбластьСтроки);
		
	КонецЦикла;
	ОбластьСтроки = Макет.ПолучитьОбласть("Подвал");
	//ОбластьСтроки.Параметры.Комментарий = Объект.Комментарий;
	ТабДокумент.Вывести(ОбластьСтроки);
	
	Возврат ТабДокумент;
	
КонецФункции // НарядНаСборкуСервер()

&НаКлиенте
Процедура ПечатьЭтикетки(Команда)
	ТабДок = ПечатьЭтикеткиСервер();
	Событие = "Распечатал этикетку " + Объект.Наименование;
	ЗаписьЛога(Событие);
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Печать");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "Печать";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	
	//ТабДокумент = ПечатьСервер("Место");
	//ТабДокумент.Показать();
	
КонецПроцедуры


&НаСервере
Функция ПечатьЭтикеткиСервер(Сортировка = Неопределено)
	ЭтотОбъект.Записать();
	// Вставить содержимое обработчика.
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина; 
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Макет       =   Справочники.Поддоны.ПолучитьМакет("Этикетка");;
	ОбластьМакета = Макет.ПолучитьОбласть("Этикетка");
	ОбластьМакета.Параметры.Поддон = Объект.Наименование;
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(""); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = объект.Наименование;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	ФайлКартинки 			             = КартинкаШтрихКод;
	ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаШтрихКод;
	
	ТабДокумент.Вывести(ОбластьМакета);	
	
	Возврат ТабДокумент;
	
КонецФункции // НарядНаСборкуСервер()






