
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//Если  пользователи.РолиДоступны("Москва") И НЕ пользователи.РолиДоступны("ПолныеПрава") тогда
	
	///+ГомзМА 28.08.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПомощникБухгалтера")) Тогда
		//ИзменитьТекстЗапросаДинамическогоСпискаСписок();
	КонецЕсли;
	///-ГомзМА 28.08.2023
	
	///+ГомзМА 19.09.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 19.09.2023
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
		НастройкиСписка = "...";	
		ПодключитьОбработчикОжидания("ПроверкаИзменения",1);
КонецПроцедуры


#КонецОбласти

&НаКлиенте
Процедура ПроверкаИзменения()
	
	НастройкиСпискаТек = "";
	Для Каждого ЭлементПользНастроек Из	Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		//тут отборы и сортировка - отловим их
		НастройкиСпискаТек = НастройкиСпискаТек + СокрЛП(ЭлементПользНастроек) + СокрЛП(Элементы.Список.Период.ДатаНачала) + СокрЛП(Элементы.Список.Период.ДатаОкончания);
	КонецЦикла;
	//тут добавим в ловушку период списка (если это список документов)
	НастройкиСпискаТек = НастройкиСпискаТек + СокрЛП(Элементы.Список.Период.ДатаНачала) + СокрЛП(Элементы.Список.Период.ДатаОкончания);
	
	Если не НастройкиСписка = НастройкиСпискаТек Тогда	
	 
	 	//чей-то поменялось
		НастройкиСписка = НастройкиСпискаТек;
		
		СчитаемИтогиНаСервере();	
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СчитаемИтогиНаСервере()
	
	//получаем схему компоновки списка
	СКД = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	//добавляем ресурсы
	ПолеИтога = СКД.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным 	= "Сумма";
	ПолеИтога.Выражение 	= "СУММА(Сумма)";
		
	//получаем настройки компоновки списка (в ней уже есть отборы и поиск)
	НастройкаСКД 	= Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	
	//очищаем поля основной группировки - получаем в итоге группировку всего запроса по "неопределено" и на выходе одну строку в результате
	НастройкаСКД.Структура[0].ПоляГруппировки.Элементы.Очистить();
	
	//нам не нужны все поля, а только наши ресурсы
	НастройкаСКД.Структура[0].Выбор.Элементы.Очистить();
	Выб = НастройкаСКД.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Выб.Поле 			= Новый ПолеКомпоновкиДанных("Сумма");
	Выб.Использование 	= Истина;
	
	//отбор проведенных
	ЭО = НастройкаСКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭО.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("Проведен");
	ЭО.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
	ЭО.ПравоеЗначение	= Истина;
	ЭО.Использование	= Истина;
	
	//результат
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СКД, НастройкаСКД,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")) ;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
   
   	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	//заполняем реквизиты итогов подвала
	СписокСуммаПодвал 		= Результат.Итог("сумма");
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры


#КонецОбласти
#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти



#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ИзменитьТекстЗапросаДинамическогоСпискаСписок()

	///+ГомзМА 28.08.2023
	Текст =  "ВЫБРАТЬ
	         |	ДокументРасходы.Ссылка КАК Ссылка,
	         |	ДокументРасходы.ПометкаУдаления КАК ПометкаУдаления,
	         |	ДокументРасходы.Номер КАК Номер,
	         |	ДокументРасходы.Дата КАК Дата,
	         |	ДокументРасходы.Проведен КАК Проведен,
	         |	ДокументРасходы.Организация КАК Организация,
	         |	ДокументРасходы.ВидРасхода КАК ВидРасхода,
	         |	ДокументРасходы.ПодтверждающийДокумент КАК ПодтверждающийДокумент,
	         |	ДокументРасходы.Сумма КАК Сумма,
	         |	ДокументРасходы.Комментарий КАК Комментарий,
	         |	ДокументРасходы.Откуда КАК Откуда,
	         |	ДокументРасходы.Зарплата КАК Зарплата,
	         |	ДокументРасходы.Работник КАК Работник,
	         |	ДокументРасходы.Месяц КАК Месяц,
	         |	ДокументРасходы.Год КАК Год,
	         |	ДокументРасходы.Новые КАК Новые,
	         |	ДокументРасходы.В1С КАК В1С,
	         |	ДокументРасходы.ВидВыдачи КАК ВидВыдачи,
	         |	ДокументРасходы.Org КАК Org,
	         |	ДокументРасходы.bank КАК bank,
	         |	ДокументРасходы.bankDate КАК bankDate,
	         |	ДокументРасходы.СчетОткудаРасход КАК СчетОткудаРасход,
	         |	ДокументРасходы.Ответственный КАК Ответственный,
	         |	ДокументРасходы.Автомобиль КАК Автомобиль,
	         |	ДокументРасходы.МаршрутныйЛист КАК МаршрутныйЛист,
	         |	ДокументРасходы.КоличествоТопливо КАК КоличествоТопливо,
	         |	ДокументРасходы.ВидОперации КАК ВидОперации,
	         |	ДокументРасходы.Контрагент КАК Контрагент,
	         |	ДокументРасходы.Основание КАК Основание,
	         |	ДокументРасходы.Подразделение КАК Подразделение,
	         |	ДокументРасходы.Проект КАК Проект,
	         |	ДокументРасходы.Инициатор КАК Инициатор,
	         |	ДокументРасходы.ЗаявкаНаРасход КАК ЗаявкаНаРасход,
	         |	ДокументРасходы.МоментВремени КАК МоментВремени,
	         |	ДокументРасходы.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	         |	ДокументРасходы.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента
	         |ИЗ
	         |	Документ.Расходы КАК ДокументРасходы";
	
	
		
		Текст = Текст + Символы.ПС + "ГДЕ" + Символы.ПС + "НЕ ДокументРасходы.Зарплата";
		Список.ТекстЗапроса = Текст;
		Текст = Текст + Символы.ПС + "И" + Символы.ПС + "ДокументРасходы.ВидРасхода <> &ВидРасхода";
		Список.ТекстЗапроса = Текст;
		Текст = Текст + Символы.ПС + "И" + Символы.ПС + "ДокументРасходы.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.Зарплата)";
		Список.ТекстЗапроса = Текст;
		
		Список.Параметры.УстановитьЗначениеПараметра("ВидРасхода", Справочники.ВидыРасходов.НайтиПоКоду("000000114"));
	///-ГомзМА 28.08.2023

КонецПроцедуры


&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()

	///+ГомзМА 19.09.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПомощникБухгалтера")) Тогда
		Элементы.ФормаВывод1.Видимость 					 = Ложь;
		Элементы.ФормаВывестиРасходы.Видимость 			 = Ложь;
		Элементы.ФормаГрафик.Видимость 					 = Ложь;
		Элементы.ФормаТаблицаРасходовПоМесяцам.Видимость = Ложь;
		Элементы.ФормаТаблицаРасходыНаЗарплату.Видимость = Ложь;
	КонецЕсли;
	///-ГомзМА 19.09.2023

КонецПроцедуры


#КонецОбласти






&НаКлиенте
Процедура Вывод1(Команда)
	ТабДокумент = Вывод1Сервер();
	ТабДокумент.Показать();

КонецПроцедуры   


// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция Вывод1Сервер()
	// Вставить содержимое обработчика.
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет("Макет");
	строка = Макет.ПолучитьОбласть("строка");
	Для Каждого стр из Список Цикл
		строка.Параметры.ном = стр.Ссылка;
		строка.Параметры.сумма = стр.Сумма;
		ТабДокумент.Вывести(строка);
	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции // Вывод1Сервер()


&НаСервере
Функция ПолучитьМакет(название)
	Возврат  Документы.Расходы.ПолучитьМакет(название);
КонецФункции

&НаКлиенте
Процедура СоздатьНовый1(Элемент)
    ФормаСписка = ПолучитьФорму("Документ.Расходы.ФормаОбъекта");
	ФормаСписка.ВладелецФормы = ЭтаФорма;
	ФормаСписка.Объект.Новые=Истина;
	Если Не ФормаСписка.Открыта() Тогда
    	ФормаСписка.ОткрытьМодально();
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ВывестиРасходы(Команда)
	ТабДокумент = ВывестиРасходыСервер();
	ТабДокумент.Показать();
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ВывестиРасходыСервер()

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет("ТоварПоПоступлению");
	ОбластьМакета = Макет.ПолучитьОбласть("заголовок"); 
	ТабДокумент.Вывести(ОбластьМакета);

	маш =  Макет.ПолучитьОбласть("поступление");
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	сум = Макет.ПолучитьОбласть("сумма");
	общ = Макет.ПолучитьОбласть("общ");
	НомерСтроки = 0;
	
	Итого = 0;
	Скидка = 0;
	машины = Новый Массив;
	пер = Элементы.Список.Период;
	результат = ВозвратЗапроса(пер.ДатаНачала,пер.ДатаОкончания);	
	расходы = Новый Массив;
	Для Каждого СтрокаТабличнойЧасти Из результат Цикл
		рез = расходы.Найти(СтрокаТабличнойЧасти.ВидРасхода);
		Если рез = неопределено Тогда
			расходы.Добавить(СтрокаТабличнойЧасти.ВидРасхода);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого расход Из расходы Цикл
		// ++ obrv 11.08.20
        //маш.Параметры.имяРасход = расход.Наименование;
        маш.Параметры.имяРасход = Строка(расход);
		// -- obrv 11.08.20
		ТабДокумент.Вывести(маш);
		НомерСтроки = 0;
		итогоМаш = 0;
		скидкаМаш = 0;
		Для Каждого СтрокаТабличнойЧасти Из результат Цикл
			Если расход = СтрокаТабличнойЧасти.ВидРасхода Тогда
				НомерСтроки = НомерСтроки + 1;
				ОбластьСтроки.Параметры.н = НомерСтроки;
				ОбластьСтроки.Параметры.дата = СтрокаТабличнойЧасти.Дата; 
				
				ОбластьСтроки.Параметры.комментарий = СтрокаТабличнойЧасти.Комментарий;
				Скидка1 = 0;
				ОбластьСтроки.Параметры.сумма = СтрокаТабличнойЧасти.Сумма;
				итогоМаш = итогоМаш + СтрокаТабличнойЧасти.Сумма;
				Итого = Итого + СтрокаТабличнойЧасти.Сумма;
							
				ТабДокумент.Вывести(ОбластьСтроки);
			КонецЕсли;
		КонецЦикла;
		сум.Параметры.сумма = итогоМаш ;
		ТабДокумент.Вывести(сум);
	КонецЦикла;

	общ.Параметры.сумма = Итого - Скидка;
	ТабДокумент.Вывести(общ); 
	
	Возврат ТабДокумент;

КонецФункции // ВывестиРасходыСервер()

&НаСервере
Функция ВозвратЗапроса(дата1,дата2)
	запрос = Новый Запрос;
	текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	        |	Расходы.Ссылка,
	        |	Расходы.ВерсияДанных,
	        |	Расходы.ПометкаУдаления,
	        |	Расходы.Номер,
	        |	Расходы.Дата,
	        |	Расходы.Проведен,
	        |	Расходы.ВидРасхода,
	        |	Расходы.ПодтверждающийДокумент,
	        |	Расходы.Сумма,
	        |	Расходы.Комментарий,
	        |	Расходы.Откуда,
	        |	Расходы.Зарплата,
	        |	Расходы.Работник,
	        |	Расходы.Месяц,
	        |	Расходы.Год
	        |ИЗ
	        |	Документ.Расходы КАК Расходы";
	текст1 = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	         |	Расходы.Ссылка,
	         |	Расходы.ВерсияДанных,
	         |	Расходы.ПометкаУдаления,
	         |	Расходы.Номер,
	         |	Расходы.Дата,
	         |	Расходы.Проведен,
	         |	Расходы.ВидРасхода,
	         |	Расходы.ПодтверждающийДокумент,
	         |	Расходы.Сумма,
	         |	Расходы.Комментарий,
	         |	Расходы.Откуда,
	         |	Расходы.Зарплата,
	         |	Расходы.Работник,
	         |	Расходы.Месяц,
	         |	Расходы.Год
	         |ИЗ
	         |	Документ.Расходы КАК Расходы
	         |ГДЕ
	         |	Расходы.Дата >= &Дата1";
	запрос.Текст=текст;
	Если дата1 = Дата("00010101000000")  И дата2 = Дата("00010101000000")  Тогда
		
	Иначе
		запрос.Текст = текст1;
		запрос.УстановитьПараметр("Дата1",дата1);
		запрос.УстановитьПараметр("Дата2",дата2);
	КонецЕсли;
	Возврат запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура График(Команда)
	// Вставить содержимое обработчика.
	гр = ПолучитьФорму("Документ.Расходы.Форма.График");
	гр.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасходовПоМесяцам(Команда)

	текДата = ТекущаяДата();
	#Если НЕ ВебКлиент Тогда
		ВвестиДату(текДата,"",ЧастиДаты.Дата);
	#КонецЕсли	
	
	текДата = НачалоМесяца(текДата);
	ТабДокумент = ТаблицаРасходовПоМесяцамСервер(текДата);
	
	ТабДокумент.Показать();
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ТаблицаРасходовПоМесяцамСервер(текДата)

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет("РасходыПоМесяцам");
	шапка = Макет.ПолучитьОбласть("шапка");
	строка = Макет.ПолучитьОбласть("строка");
	подвал = Макет.ПолучитьОбласть("подвал");
	послДата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),1);
	
	ИспользоватьКопейки = ПолучитьФункциональнуюОпцию("дт_ИспользоватьКопейки", Новый Структура("ВидДокумента", "Расходы"));
	
	Пока текДата <> послДата Цикл
		шапка.Параметры.период = "Расходы за "+Формат(текДата, "ДФ=""ММММ гггг 'г.'""");
		ТабДокумент.Вывести(шапка);
		расх = РасчетРасходовПоМесяцам(текДата,КонецМесяца(текДата));
		сумма = 0;
		Для Каждого стр из расх Цикл
			строка.Параметры.категория = стр.ВидРасходаНаименование;
			СуммаПоДокументу = стр.Сумма;
			
			Если НЕ ИспользоватьКопейки Тогда
				СуммаПоДокументу = Цел(СуммаПоДокументу);
			КонецЕсли;
			
			строка.Параметры.сумма = ?(ИспользоватьКопейки, Формат(СуммаПоДокументу, "ЧДЦ=2"), СуммаПоДокументу);
			сумма = сумма + СуммаПоДокументу;
			ТабДокумент.Вывести(строка);
		КонецЦикла;		
		подвал.Параметры.сумма =  ?(ИспользоватьКопейки, Формат(Сумма, "ЧДЦ=2"), Сумма);
		ТабДокумент.Вывести(подвал);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		текДата = ДобавитьМесяц(текДата,1);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции // ТаблицаРасходовПоМесяцам()


&НаСервере
Функция РасчетРасходовПоМесяцам(ДатаНачала, ДатаОкончания)
	запрос = Новый Запрос;
	
	// ++ obrv 10.05.18
	запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасходыОбороты.ВидРасхода КАК ВидРасхода,
	|	ЕСТЬNULL(РасходыОбороты.ВидРасхода.Зарплата, ЛОЖЬ) КАК ЭтоРасходыПоЗарплате,
	|	РасходыОбороты.ДокНо КАК ДокНо,
	|	РасходыОбороты.СуммаОборот КАК СуммаОборот,
	|	ЕСТЬNULL(ВидыРасходов.Наименование, """") КАК ВидРасходаНаименование,
	|	ВидыРасходов.Пользователь КАК Пользователь
	|ПОМЕСТИТЬ ВТ_Обороты
	|ИЗ
	|	РегистрНакопления.Расходы.Обороты(&Дата1, &Дата2, , ) КАК РасходыОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыРасходов КАК ВидыРасходов
	|		ПО РасходыОбороты.ВидРасхода = ВидыРасходов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Обороты.ВидРасхода КАК ВидРасхода,
	|	ВТ_Обороты.СуммаОборот КАК СуммаОборот,
	|	ВТ_Обороты.ВидРасходаНаименование КАК ВидРасходаНаименование
	|ПОМЕСТИТЬ ВТ_РасходыПрочие
	|ИЗ
	|	ВТ_Обороты КАК ВТ_Обороты
	|ГДЕ
	|	НЕ ВТ_Обороты.ЭтоРасходыПоЗарплате
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Обороты.Пользователь КАК Пользователь,
	|	МАКСИМУМ(ДолжностиСотрудниковСрезПоследних.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_ПоследняяДатаДолжностейСотрудника
	|ИЗ
	|	ВТ_Обороты КАК ВТ_Обороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДолжностиСотрудников.СрезПоследних(&Дата2, ) КАК ДолжностиСотрудниковСрезПоследних
	|			ПО Сотрудники.Ссылка = ДолжностиСотрудниковСрезПоследних.Сотрудник
	|		ПО (Сотрудники.Пользователь = ВТ_Обороты.Пользователь)
	|			И (ВТ_Обороты.ЭтоРасходыПоЗарплате)
	|ГДЕ
	|	НЕ ДолжностиСотрудниковСрезПоследних.Регистратор ССЫЛКА Документ.УвольненияСотрудников
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Обороты.Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПоследняяДатаДолжностейСотрудника.Пользователь КАК Пользователь,
	|	ДолжностиСотрудниковСрезПоследних.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ втПодразделенияСотрудников
	|ИЗ
	|	ВТ_ПоследняяДатаДолжностейСотрудника КАК ВТ_ПоследняяДатаДолжностейСотрудника
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|		ПО ВТ_ПоследняяДатаДолжностейСотрудника.Период = ДолжностиСотрудниковСрезПоследних.Период
	|			И ВТ_ПоследняяДатаДолжностейСотрудника.Пользователь = ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_Обороты.СуммаОборот) КАК СуммаОборот,
	|	ПодразделенияСотрудников.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ_РасходыПоЗарплате
	|ИЗ
	|	ВТ_Обороты КАК ВТ_Обороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПодразделенияСотрудников КАК ПодразделенияСотрудников
	|		ПО (ПодразделенияСотрудников.Пользователь = ВТ_Обороты.Пользователь)
	|ГДЕ
	|	ВТ_Обороты.ЭтоРасходыПоЗарплате
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодразделенияСотрудников.Подразделение
	|
	|ИМЕЮЩИЕ
	|	НЕ СУММА(ВТ_Обороты.СуммаОборот) ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЛичныйВывод.Сумма) КАК Сумма,
	|	&ЛичныйВыводНаименование КАК ВидРасходаНаименование
	|ПОМЕСТИТЬ ВТ_РасходыЛичныйВывод
	|ИЗ
	|	Документ.ЛичныйВывод КАК ЛичныйВывод
	|ГДЕ
	|	ЛичныйВывод.Проведен
	|	И ЛичныйВывод.Дата МЕЖДУ &Дата1 И &Дата2
	|
	|ИМЕЮЩИЕ
	|	НЕ СУММА(ЛичныйВывод.Сумма) ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_РасходыПрочие.ВидРасходаНаименование КАК ВидРасходаНаименование,
	|	"""" КАК Префикс,
	|	ВТ_РасходыПрочие.СуммаОборот КАК Сумма
	|ИЗ
	|	ВТ_РасходыПрочие КАК ВТ_РасходыПрочие
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВТ_РасходыПоЗарплате.Подразделение),
	|	""Зарплата "",
	|	ВТ_РасходыПоЗарплате.СуммаОборот
	|ИЗ
	|	ВТ_РасходыПоЗарплате КАК ВТ_РасходыПоЗарплате
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_РасходыЛичныйВывод.ВидРасходаНаименование,
	|	"""",
	|	ВТ_РасходыЛичныйВывод.Сумма
	|ИЗ
	|	ВТ_РасходыЛичныйВывод КАК ВТ_РасходыЛичныйВывод
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сумма УБЫВ";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЛичныйВывод) Тогда
		ЗапросЛичныйВывод = 
		"ВЫБРАТЬ
		|	СУММА(ЛичныйВывод.Сумма) КАК Сумма,
		|	&ЛичныйВыводНаименование КАК ВидРасходаНаименование
		|ПОМЕСТИТЬ ВТ_РасходыЛичныйВывод2
		|ИЗ
		|	Документ.ЛичныйВывод КАК ЛичныйВывод
		|ГДЕ
		|	ЛичныйВывод.Проведен
		|	И ЛичныйВывод.Дата МЕЖДУ &Дата1 И &Дата2
		|
		|ИМЕЮЩИЕ
		|	НЕ СУММА(ЛичныйВывод.Сумма) ЕСТЬ NULL";
		
	Иначе
		ЗапросЛичныйВывод = 
		"ВЫБРАТЬ
		|	0 КАК Сумма,
		|	&ЛичныйВыводНаименование КАК ВидРасходаНаименование
		|ПОМЕСТИТЬ ВТ_РасходыЛичныйВывод2
		|ГДЕ
		|	ЛОЖЬ";
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ";" + Символы.ПС + ЗапросЛичныйВывод + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|" + 
	"ВЫБРАТЬ
	|	ВТ_РасходыПрочие.ВидРасходаНаименование КАК ВидРасходаНаименование,
	|	"""" КАК Префикс,
	|	ВТ_РасходыПрочие.СуммаОборот КАК Сумма
	|ИЗ
	|	ВТ_РасходыПрочие КАК ВТ_РасходыПрочие
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВТ_РасходыПоЗарплате.Подразделение),
	|	""Зарплата "" КАК Префикс,
	|	ВТ_РасходыПоЗарплате.СуммаОборот
	|ИЗ
	|	ВТ_РасходыПоЗарплате КАК ВТ_РасходыПоЗарплате
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_РасходыЛичныйВывод2.ВидРасходаНаименование,
	|	"""" КАК Префикс,
	|	ВТ_РасходыЛичныйВывод2.Сумма
	|ИЗ
	|	ВТ_РасходыЛичныйВывод2 КАК ВТ_РасходыЛичныйВывод2
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сумма УБЫВ";
	
	Запрос.УстановитьПараметр("Дата1", ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", ДатаОкончания);
	Запрос.УстановитьПараметр("ЛичныйВыводНаименование", Метаданные.Документы.ЛичныйВывод.Синоним);
	// -- obrv 10.05.18
	Рез = запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из Рез Цикл
		СтрокаТаблицы.ВидРасходаНаименование = СтрокаТаблицы.Префикс + СтрокаТаблицы.ВидРасходаНаименование; 
	КонецЦикла;
	
	
	возврат Рез;
КонецФункции

&НаКлиенте
Процедура ТаблицаРасходыНаЗарплату(Команда)

	текДата = ТекущаяДата();
	#Если НЕ ВебКлиент Тогда
		ВвестиДату(текДата,"",ЧастиДаты.Дата);
	#КонецЕсли
		
	текДата = НачалоМесяца(текДата);
	ТабДокумент = ТаблицаРасходыНаЗарплатуСервер(текДата);
	ТабДокумент.Показать();
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ТаблицаРасходыНаЗарплатуСервер(текДата)

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет("РасходыПоМесяцам");
	шапка = Макет.ПолучитьОбласть("шапка");
	строка = Макет.ПолучитьОбласть("строка");
	подвал = Макет.ПолучитьОбласть("подвал");
	ии = 0;
	послДата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),1);
	
	ИспользоватьКопейки = ПолучитьФункциональнуюОпцию("дт_ИспользоватьКопейки", Новый Структура("ВидДокумента", "Расходы"));
	
	Пока текДата <> послДата Цикл
		// ++ obrv 10.05.18
		//шапка.Параметры.период = "Расходы за "+Формат(текДата, "ДФ=""ММММ гггг 'г.'""");
		шапка.Параметры.период = "Расходы на зарплату за "+Формат(текДата, "ДФ=""ММММ гггг 'г.'""");
		// -- obrv 10.05.18
		ТабДокумент.Вывести(шапка);
		расх = РасчетРасходовНаЗпПоМесяцам(Месяц(текДата),Год(текДата));
		сумма = 0;
		Для Каждого стр из расх Цикл
			строка.Параметры.категория = стр.ВидРасходаНаименование;
			
			СуммаПоДокументу = стр.Сумма;
			
			Если НЕ ИспользоватьКопейки Тогда
				СуммаПоДокументу = Цел(СуммаПоДокументу);
			КонецЕсли;
			
			строка.Параметры.сумма = ?(ИспользоватьКопейки, Формат(СуммаПоДокументу, "ЧДЦ=2"), СуммаПоДокументу);
			сумма = сумма + СуммаПоДокументу;
			ТабДокумент.Вывести(строка);
		КонецЦикла;		
		подвал.Параметры.сумма =  ?(ИспользоватьКопейки, Формат(Сумма, "ЧДЦ=2"), Сумма);
		ТабДокумент.Вывести(подвал);
		ии = ии+1;
		Если ии = 4 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		текДата = ДобавитьМесяц(текДата,1);
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции // ТаблицаРасходыНаЗарплатуСервер()

&НаСервере
Функция РасчетРасходовНаЗпПоМесяцам(месяц,год)
	запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СУММА(Расходы.Сумма) КАК Сумма,
	               |	Расходы.ВидРасхода.Наименование
	               |ИЗ
	               |	Документ.Расходы КАК Расходы
	               |ГДЕ
	               |	Расходы.Зарплата = ИСТИНА
	               |	И Расходы.Месяц = &Месяц
	               |	И Расходы.Год = &Год
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Расходы.ВидРасхода	         
	               |УПОРЯДОЧИТЬ ПО
	               |	Сумма УБЫВ";
	запрос.УстановитьПараметр("Месяц",месяц);
	запрос.УстановитьПараметр("Год",год);
	рез = запрос.Выполнить().Выгрузить();
	возврат рез;
КонецФункции

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("ОстаткиБалансИзменение");
	
КонецПроцедуры



