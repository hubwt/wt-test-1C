
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///+ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	ЗаполнениеСписков();
	ОбновлениеСписка();
	///-ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	
	Если пользователи.РолиДоступны("КассаМосква") и не пользователи.РолиДоступны("ПолныеПрава") И НЕ ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя = "Урунов Муминджон Мойдинович" тогда
		список.Параметры.УстановитьЗначениеПараметра("город",Справочники.Город.НайтиПоКоду("000000005"));
	КонецЕсли;
	
	///+ГомзМА 28.08.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 28.08.2023
	
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
  ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
  ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаПрихода");
  ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
  ЭлементОтбора.ПравоеЗначение = Истина;
  ЭлементОтбора.Использование = Истина;
  ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоКоралловый);
	
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("ОстаткиБалансИзменение");
КонецПроцедуры


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
	ПолеИтога.ПутьКДанным 	= "СуммаДокумента";
	ПолеИтога.Выражение 	= "СУММА(СуммаДокумента)";
		
	//получаем настройки компоновки списка (в ней уже есть отборы и поиск)
	НастройкаСКД 	= Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	
	//очищаем поля основной группировки - получаем в итоге группировку всего запроса по "неопределено" и на выходе одну строку в результате
	НастройкаСКД.Структура[0].ПоляГруппировки.Элементы.Очистить();
	
	//нам не нужны все поля, а только наши ресурсы
	НастройкаСКД.Структура[0].Выбор.Элементы.Очистить();
	Выб = НастройкаСКД.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Выб.Поле 			= Новый ПолеКомпоновкиДанных("СуммаДокумента");
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
	СписокСуммаПодвал 		= Результат.Итог("СуммаДокумента");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		НастройкиСписка = "...";	
		ПодключитьОбработчикОжидания("ПроверкаИзменения",1);
КонецПроцедуры


&НаКлиенте
Процедура ОтборПоМенеджеруПриИзменении(Элемент)
	
	ОбновлениеСписка();
	СчитаемИтогиНаСервере();
	
КонецПроцедуры


Процедура ОбновлениеСписка()
	
	///+ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	Если ЗначениеЗаполнено(ОтборПоМенеджеру) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		ОтборПоМенеджеру, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ИначеЕсли ОтборПоМенеджеру = Справочники.Пользователи.ПустаяСсылка() Тогда 
		Элементы.Список.Обновить();
	Иначе
		ДоступныеМенеджеры = Элементы.ОтборПоМенеджеру.СписокВыбора.ВыгрузитьЗначения();
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		ДоступныеМенеджеры, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	
	КонецЕсли;
	///-ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	
КонецПроцедуры
&НаСервере
Процедура ЗаполнениеСписков()
	
	///+ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	ЗапросМенеджеров = Новый Запрос;
	ЗапросМенеджеров.Текст = 
	"ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь КАК СотрудникПользователь,
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Фамилия КАК Представление
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Должность.Отдел В(&Отдел)
	|	И НЕ ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь.Недействителен
	|
	|УПОРЯДОЧИТЬ ПО
	|	СотрудникПользователь";
	
	Отдел = Новый Массив;
	Отдел.Добавить(Справочники.Подразделения.НайтиПоКоду("000000076"));
	Отдел.Добавить(Справочники.Подразделения.НайтиПоКоду("000000077"));
	
	ЗапросМенеджеров.УстановитьПараметр("Отдел", Отдел);
	ВыборкаМенеджеров = ЗапросМенеджеров.Выполнить().Выбрать();
	
	Элементы.ОтборПоМенеджеру.СписокВыбора.Очистить();
	Элементы.ОтборПоМенеджеру.СписокВыбора.Добавить(Справочники.Пользователи.ПустаяСсылка(), "ВСЕ");
	Элементы.ОтборПоМенеджеру.СписокВыбора.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Мустяца Роман Павлович"), "Мустяца");
	Элементы.ОтборПоМенеджеру.СписокВыбора.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Ягофаров Николай Дмитриевич"), "Ягофаров");

	Пока ВыборкаМенеджеров.Следующий() Цикл
		Элементы.ОтборПоМенеджеру.СписокВыбора.Добавить(ВыборкаМенеджеров.СотрудникПользователь, ВыборкаМенеджеров.Представление);
	КонецЦикла;
	
	///-ГомзМА 14.02.2023 (Задача 000002720 от 14.02.2023)
	
КонецПроцедуры


&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()

	///+ГомзМА 28.08.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава")) ИЛИ
		 ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_Зарплата")) Тогда 
	Элементы.Ответственный.Видимость = Истина;
	КонецЕсли;
	///-ГомзМА 28.08.2023

КонецПроцедуры