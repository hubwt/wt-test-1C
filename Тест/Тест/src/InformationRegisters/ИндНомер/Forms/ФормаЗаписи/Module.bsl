&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Запись.АвтоВыгрНаАвитоНетВАвито = Перечисления.АвтоВыгрНаАвитоНетВАвито.ПродаетсяВАвито Тогда 
		Элементы.АккаунтАвито.Видимость = Истина; 
	Иначе 
		Элементы.АккаунтАвито.Видимость = Ложь; 
	КонецЕсли;
	СформироватьСписокВыбора(); 
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименование(Команда)
	Если НЕ ЗначениеЗаполнено(Запись.Наименование) Тогда 
		Запись.Наименование = ЗаполнитьНаименованиеНаСервере();
	конецЕсли; 
КонецПроцедуры

&НаСервере
Функция ЗаполнитьНаименованиеНаСервере()
	НаименованиеобъявленияАвито	= Строка(Запись.индкод.Владелец); 
	Возврат НаименованиеобъявленияАвито; 
КонецФункции

&НаКлиенте
Процедура ЗаполнитьОписание(Команда)
	
	ЗаполнитьОписаниеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписаниеНаСервере()
	
	Если ЗначениеЗаполнено( Запись.Наименование) Тогда 
		НаименованиеАвито  	= Строка(Запись.Наименование);
		индкодАвито 		= Строка(Запись.индкод);  
		
		Строка = 
				НаименованиеАвито + " Инд Код: " +  индкодАвито +
				" Пишите в любой время, отвечаю и днем и ночью, без выходных. 
				|Часовой пояс не проблема ))) 
				|
				|❤️ Добавьте объявление в Избранное, чтобы не потерять нас! 
				|
				|• Гарантия 1 месяц 
				|• Продажа с НДС. 
				|• Рассрочка. 
				|• Гарантия низкой цены — найдем для вас выгодное решение! 
				|• Доставка по России (возможна бесплатная). 
				|
				|Отправляем в города России как СДЭКом, Деловыми Линиями так и Авиа Доставкой. 
				|
				|С нами вы осуществите качественный ремонт тягача Scania, R, P, G, S. 5 и 6 series 
				|
				|Переходите в наш профиль что бы посмотреть ещё больше товаров в нашем АВИТО Магазине. 
				|
				|Нас можно найти на Авито так же по следующим запросам: 
				|
				|Запчасти Скания 
				|Разборка Скания 
				|Ремонт Скания 
				|Авторазбор Скания 
				|Разборка грузовиков Скания 
				|Разбор Скания"; 
		
		Запись.Описание = Строка;
	Иначе 
		Сообщение = Новый СообщениеПользователю();
		Сообщение.текст = "Наименование не заполннено";
		Сообщение.Сообщить(); 
	КонецЕсли; 	
	
КонецПроцедуры





&НаКлиенте
Процедура ПоказатьДопПараметры(Команда)
	
	Элементы.СостояниеАвито.Видимость = истина; 
	Элементы.Доступность.Видимость = истина; 
	Элементы.Происхождение.Видимость = истина; 
	Элементы.НДСВключён.Видимость = истина; 
	Элементы.ОтсрочкаПлатежа.Видимость = истина; 
КонецПроцедуры

&НаКлиенте
Процедура АккаунтАвитоПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Запись.АккаунтАвито) Тогда 
		Запись.ТелефонМенеджера =  ОпределитьНомерТелефонаСлужебный(Запись.АккаунтАвито);
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьНомерТелефонаСлужебный(Имя)
	
	Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
			|	СотрудникиКонтактнаяИнформация.Представление КАК СлужебныйНомер
			|ИЗ
			|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
			|ГДЕ
			|	СотрудникиКонтактнаяИнформация.Ссылка.Пользователь.Наименование = &Имя
			|	И СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаСлужебный)";
		
		Запрос.УстановитьПараметр("Имя", Имя);
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		Возврат ВыборкаДетальныеЗаписи.СлужебныйНомер;
		
КонецФункции


&НаСервере
Функция СформироватьСписокВыбора()

МассивДолжностей = Новый Массив; 
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000112")); // Помощник менеджера по продажам !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000143")); // Проектный менеджер !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000083")); // Текстовый Менеджер !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000103")); // Менеджер по работе с клиентами в отделе качества !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000003")); // Менеджер по продажам.
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000012")); // SMM менеджер !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000058")); // Заместитель руководителя отдела продаж!
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000005")); // Руководитель отдела продаж !
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000067")); // Руководитель отдела рекламы !000000117
МассивДолжностей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000117")); // Директор .

Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	КадровыйПриказ.Сотрудник.Пользователь.Наименование КАК СотрудникПользовательНаименование,
	|	КадровыйПриказ.Сотрудник.Пользователь КАК СотрудникПользователь,
	|	МАКСИМУМ(КадровыйПриказ.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ВТ_КадровыйПриказПоследние
	|ИЗ
	|	Документ.КадровыйПриказ КАК КадровыйПриказ
	|СГРУППИРОВАТЬ ПО
	|	КадровыйПриказ.Сотрудник.Пользователь,
	|	КадровыйПриказ.Сотрудник.Пользователь.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_КадровыйПриказПоследние.СотрудникПользовательНаименование КАК СотрудникПользовательНаименование,
	|	ВТ_КадровыйПриказПоследние.Ссылка.Должность КАК СсылкаДолжность
	|ИЗ
	|	ВТ_КадровыйПриказПоследние КАК ВТ_КадровыйПриказПоследние
	|ГДЕ
	|	ВТ_КадровыйПриказПоследние.Ссылка.Должность В (&Должность)";

Запрос.УстановитьПараметр("Должность", МассивДолжностей);
РезультатЗапроса = Запрос.Выполнить();

Выборка = РезультатЗапроса.Выбрать();

Пока Выборка.Следующий() Цикл
	Элементы.АккаунтАвито.СписокВыбора.Добавить(Выборка.СотрудникПользовательНаименование);
КонецЦикла;
	Элементы.АккаунтАвито.СписокВыбора.Добавить("Общий");
КонецФункции

&НаКлиенте
Процедура АвтоВыгрНаАвитоНетВАвитоПриИзменении(Элемент)
	Структура = ВернутьПеречисление(); 
	Если Запись.АвтоВыгрНаАвитоНетВАвито = Структура.ПродаетсяВАвито  Тогда 
		Элементы.АккаунтАвито.Видимость = Истина; 
	Иначе 
		Элементы.АккаунтАвито.Видимость = Ложь; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере 
Функция ВернутьПеречисление()
	
	ПродаетсяВАвито = Перечисления.АвтоВыгрНаАвитоНетВАвито.ПродаетсяВАвито; 
	НетВАвито  = Перечисления.АвтоВыгрНаАвитоНетВАвито.НетВАвито; 
	Структура = Новый Структура;
	Структура.Вставить("ПродаетсяВАвито",ПродаетсяВАвито);
	Структура.Вставить("НетВАвито",НетВАвито);
	Возврат Структура ;
КонецФункции 


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЗаписьИсторииЦен = РегистрыСведений.ИсторияИзмененияЦен.СоздатьМенеджерЗаписи();
	ЗаписьИсторииЦен.Дата = ТекущаяДата();
	ЗаписьИсторииЦен.ИндНомер = Справочники.ИндКод.НайтиПоНаименованию(запись.индкод);
	//ЗаписьИсторииЦен.Ответственный = Пользователи.ТекущийПользователь();
	ЗаписьИсторииЦен.ОтветственныйПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
	ЗаписьИсторииЦен.Цена = Запись.Цена;
	ЗаписьИсторииЦен.Записать();	
КонецПроцедуры

&НаСервере
Функция СоздатьПеремещениеНаСервере()
	
	///+ГомзМА 01.09.2023
	НовыйДокумент = Документы.УстановкаМестХранения.СоздатьДокумент();
	НовыйДокумент.Дата = ТекущаяДатаСеанса();
	НовыйДокумент.Склад = Справочники.Склады.НайтиПоКоду("000000002");
	НовыйДокумент.Ответственный = Пользователи.ТекущийПользователь();
	НоваяСтрока = НовыйДокумент.Товары.Добавить();
	НоваяСтрока.Номенклатура = Запись.индкод.Владелец;
	НоваяСтрока.МестоХраненияПолучатель = МестоХранения;
	НовыйДокумент.Записать();
	
	Возврат НовыйДокумент.Ссылка;
	///-ГомзМА 01.09.2023
	
КонецФункции

&НаКлиенте
Процедура СоздатьПеремещение(Команда)
	
	///+ГомзМА 01.09.2023
	СсылкаНаДокумент = СоздатьПеремещениеНаСервере();
	//ОткрытьЗначение(СсылкаНаДокумент);
	
	ПараметрыОткрытия = Новый Структура("Ключ", СсылкаНаДокумент);
	
	ОткрытьФорму("Документ.УстановкаМестХранения.ФормаОбъекта", ПараметрыОткрытия);
	///-ГомзМА 01.09.2023
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьГексагон(Команда)
	Отказ = истина;
	
	ВыполняемаяКоманда = Новый Структура("ЭтоОтчет, Ссылка, Идентификатор", ложь);
	ВыполняемаяКоманда.Ссылка = получитьВнешку();
	
	Если ВыполняемаяКоманда.Ссылка = Неопределено Тогда
		// ПоказатьПредупреждение(, «Не найдена дополнительная внешняя обработка с именем объекта КлиентБанк!»);
		Возврат;
	КонецЕсли;
	
	ОбъектыНазначения = Неопределено;
	ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, ЭтаФорма, ОбъектыНазначения);КонецПроцедуры

Функция получитьВнешку()
	Возврат	Справочники.ДополнительныеОтчетыИОбработки.НайтиПоНаименованию("Гексагон Печать этикеток");
КонецФункции

&НаКлиенте
Процедура АвитоЧастникПриИзменении(Элемент)

	Если ПроверкаИндКода() > 1 и НЕ ПроверкаВладельца() Тогда
		Сообщить("Стоп! На один Инд. код можно учесть только ОДНУ деталь.");
		Запись.АвитоЧастник = Ложь;
		Возврат;
		//Прервать;
	КонецЕсли;
	
	Если Запись.АвитоЧастник Тогда
		запись.ДатаИзмененияКонвеера = ТекущаяДата();
		запись.Ответственный = НашПользователь();
		АвитоЧастникПриИзмененииНаСервере();
	КонецЕсли;
	
	///+ГомзМА 13.12.2023
	Событие = "Установил галочку " + Элементы.АвитоЧастник.Заголовок;
	ЗаписьЛога(Событие, ТекущаяДата());
	
	Событие = "Сменил цену на: " + запись.Цена;
	ЗаписьЛога(Событие, ТекущаяДата() + 1);
	
	Событие = "Сменил стеллаж на: " + запись.Стеллаж;
	ЗаписьЛога(Событие, ТекущаяДата() + 2);
	
	Событие = "Сменил состояние на: " + запись.Состояние;
	ЗаписьЛога(Событие, ТекущаяДата() + 3);
	///-ГомзМА 13.12.2023
	
КонецПроцедуры



&НаСервере
Функция ПроверкаИндКода() 
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|ГДЕ
	|	РегистрНакопления1Остатки.индкод = &ПроверкаКода";
	Запрос.УстановитьПараметр("ПроверкаКода", Запись.индкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Возврат выборка.КолвоОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции 

&НаСервере
Функция ПроверкаВладельца() 
	Возврат Запись.индкод.Владелец.Комплектация;
КонецФункции


&НаСервере
Процедура АвитоЧастникПриИзмененииНаСервере()
	
	///+ГомзМА 27.05.2024
	ТекущийПользователь = ПолучитьТекущегоПользователя();
	Если ТекущийПользователь.Подразделение = справочники.Подразделения.НайтиПоКоду("000000030") Тогда //Устарела - ВОРКТРАК Нижний Новгород - Устарела
		Запись.Стеллаж = Справочники.Стеллаж.НайтиПоКоду("000001072"); //2_ANGAR
	ИначеЕсли ТекущийПользователь.Подразделение = справочники.Подразделения.НайтиПоКоду("000000029") Тогда //Филиал Москва - Действующий
		Запись.Стеллаж = Справочники.Стеллаж.НайтиПоКоду("000002014"); //RegionMSK
	ИначеЕсли ТекущийПользователь.Подразделение = справочники.Подразделения.НайтиПоКоду("000000060") Тогда //Филиал Екатеринбург - Действующий
		Запись.Стеллаж = Справочники.Стеллаж.НайтиПоКоду("000001068"); //RegionEKB
	КонецЕсли; 
	///-ГомзМА 27.05.2024
	Запись.Цена = Запись.индкод.Владелец.РекомендованаяЦена;
	/// Комлев 03/09/24 +++ 
	Запись.Состояние = Запись.индкод.Владелец.Состояние;
	/// Комлев 03/09/24 --- 
КонецПроцедуры


Функция НашПользователь()
	Возврат Пользователи.ТекущийПользователь();
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	///+ГомзМА 13.12.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 13.12.2023
	///+ГомзМА 08.09.2023
	//Если Запись.Цена = 0 Тогда
	//	Элементы.ЦенаПроверена.ТолькоПросмотр = Истина;
	//КонецЕсли;
	///-ГомзМА 08.09.2023
	ВыводЛога();
	
	///+ГомзМА 27.05.2024
	ТекущийПользователь = ПолучитьТекущегоПользователя();
		
	МассивМенеджеров = ПолучитьМенеджеровПоПродаже();
	
	Для Каждого Менеджер Из МассивМенеджеров Цикл
		Если Менеджер = ТекущийПользователь Тогда
			МенеджерРазрешен = ПроверитьМенеджера(Менеджер);
			Если НЕ МенеджерРазрешен Тогда
				Элементы.АвитоЧастник.ТолькоПросмотр = Истина;
				Элементы.Печатьэтикетки.Видимость = Ложь;
				Элементы.ПечатьСПросмотром.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	///-ГомзМА 27.05.2024	
	
	Запись.СостояниеАвито 	= ПредопределенноеЗначение("Перечисление.СостояниеАвито.БУ");  
	Запись.Доступность 		= ПредопределенноеЗначение("Перечисление.АвитоДоступность.ВНаличии");  
	Запись.Происхождение 	= ПредопределенноеЗначение("Перечисление.ПроисхождениеАвито.Оригинал"); 
	Запись.НДСВключён 		= ПредопределенноеЗначение("Перечисление.НДСВключён.Да"); 
	Запись.ОтсрочкаПлатежа 	= ПредопределенноеЗначение("Перечисление.ОтсрочкаПлатежа.Да"); 
	
		
КонецПроцедуры
 
Функция ПолучитьТекущегоПользователя()
	
	ТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
	
	Возврат ТекущийПользователь;
	
КонецФункции

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	///+ГомзМА 08.09.2023
	Если Запись.Цена = 0 Тогда
		Элементы.ЦенаПроверена.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ЦенаПроверена.ТолькоПросмотр = Ложь;
	КонецЕсли;
	///-ГомзМА 08.09.2023
	Событие = "Сменил цену на: " + запись.Цена;
	ЗаписьЛога(Событие, ТекущаяДата());
	/// +++ Комлев +++ 10/10/24 
	Запись.ЦенаПроверена = Истина;	
	/// --- Комлев --- 	10/10/24 
КонецПроцедуры



&НаКлиенте
Процедура Печатьэтикетки(Команда) 
	Если ПроверкаИндКода() > 1 и НЕ ПроверкаВладельца() Тогда
		Сообщить("Стоп! На один Инд. код можно учесть только ОДНУ деталь.");
		Запись.АвитоЧастник = Ложь;
		Возврат;
		//Прервать;
	КонецЕсли;
	
	Если  НЕ ПроверкаПользователя() Тогда
		Сообщить("Не-не-не. Проводим через конвейер только товары из своего региона!");
		Запись.АвитоЧастник = Ложь;
		Возврат;
		//Прервать;
	КонецЕсли;	
	
	
	запись.ДатаИзмененияКонвеера = ТекущаяДата();
	запись.Ответственный = НашПользователь();
	АвитоЧастникПриИзмененииНаСервере();
	
	
	///+ГомзМА 13.12.2023

	
	ТабДок = ПечатьэтикеткиСерв(запись.индкод);
	
		Событие = "Установил галочку " + Элементы.АвитоЧастник.Заголовок;
	ЗаписьЛога(Событие, ТекущаяДата());
	
	Событие = "Сменил цену на: " + запись.Цена;
	ЗаписьЛога(Событие, ТекущаяДата() + 1);
	
	Событие = "Сменил стеллаж на: " + запись.Стеллаж;
	ЗаписьЛога(Событие, ТекущаяДата() + 2);
	
	Событие = "Сменил состояние на: " + запись.Состояние;
	ЗаписьЛога(Событие, ТекущаяДата() + 3);
	
	ТабДок.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
	//// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	//КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьэтикеткиСерв");
	//// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	//КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	//// если требуется устанавливаем параметры печати
	//КоллекцияПечатныхФорм[0].Экземпляров=1;
	//КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьэтикеткиСерв";  // используется для формирования имени файла при сохранении из общей формы печати документов
	//// .. и выводим стандартной процедурой БСП
	//УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	
	///+ГомзМА 13.12.2023
	Событие = "Распечатал бирку";
	ЗаписьЛога(Событие, ТекущаяДата());
	///-ГомзМА 13.12.2023

// ++ Начисляем Бонусы учетчикам  
	НачислениеБонусовУчетчикам(); 
// -- Начисляем Бонусы учетчикам  

	Запись.АвитоЧастник = Истина;
КонецПроцедуры

&НаСервере
Процедура	НачислениеБонусовУчетчикам()

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ЗаказКлиентаТовары.Номенклатура.Код КАК Код,
		|	МАКСИМУМ(ЗаказКлиентаТовары.Ссылка.Дата) КАК дата,
		|	МАКСИМУМ(ЕСТЬNULL(РегистрНакопления1Остатки.КолвоОстаток, 0)) КАК КолвоОстаток
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО (ЗаказКлиентаТовары.Ссылка.Ответственный = Сотрудники.Пользователь)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|		ПО (ЗаказКлиентаТовары.Номенклатура = РегистрНакопления1Остатки.Товар)
		|ГДЕ
		|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И РегистрНакопления1Остатки.КолвоОстаток < 10
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиентаТовары.Номенклатура.Код
		|
		|УПОРЯДОЧИТЬ ПО
		|	дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	КодНоменклатурыИндКода = Запись.индкод.Владелец.Код; 
	НачислитьБонус = Ложь; 
	Пока Выборка.Следующий() Цикл
		Если КодНоменклатурыИндКода =  Выборка.Код Тогда 
			НачислитьБонус = Истина; 
			Прервать;  
		КонецЕсли; 
	КонецЦикла;
	
	Если НачислитьБонус = ИСТИНА  Тогда 
		
		// ++ Проверка на уже сущесствующую запись 
		ЗаписьВРегистреСведений 			= РегистрыСведений.БонусыУчетчикиРазборщики.СоздатьНаборЗаписей();
		ЗаписьВРегистреСведений.Отбор.ИндКод.Установить(Запись.индкод); 
		ЗаписьВРегистреСведений.Прочитать();
		// -- Проверка на уже сущесствующую запись 
		
		
		// ++ Записываем в регистр бонус
		// ++ Если индкод не прошел конвеер разрешать записывать бонусы 
		Если  ЗаписьВРегистреСведений.Количество() = 0 И Запись.АвитоЧастник = ЛОЖЬ Тогда 
			ЗаписьВРегистреСведений 					= РегистрыСведений.БонусыУчетчикиРазборщики.СоздатьМенеджерЗаписи();
				Если Запись.Ответственный 				<> Справочники.Пользователи.ПустаяСсылка() Тогда 
					ЗаписьВРегистреСведений.Сотрудник	= Запись.Ответственный; 
				Иначе 
					ИмяТекПользователя 					= ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя;  
					СсылкаТекПользователя 				= Справочники.Пользователи.НайтиПоНаименованию(ИмяТекПользователя);    
					ЗаписьВРегистреСведений.Сотрудник	= СсылкаТекПользователя;
				КонецЕсли; 	
			ЗаписьВРегистреСведений.ИндКод 			= Запись.индкод;
			ЗаписьВРегистреСведений.Цена			= Запись.Цена;
			ЗаписьВРегистреСведений.Бонус			= ЗаписьВРегистреСведений.Цена * 0.005; 
			ЗаписьВРегистреСведений.Период			= ТекущаяДата(); 
				
				Если ЗначениеЗаполнено(Запись.Номенклатура) И ЗначениеЗаполнено(Запись.Машина)  Тогда 
					ЗаписьВРегистреСведений.Номенклатура	= Запись.Номенклатура; 
					ЗаписьВРегистреСведений.Машина			= Запись.Машина;
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Номенклатура	= Структура.Номенклатура; 
					ЗаписьВРегистреСведений.Машина			= Структура.Машина;
				КонецЕсли; 
				
				Если ЗначениеЗаполнено(Запись.Номенклатура)  Тогда 
					ЗаписьВРегистреСведений.Номенклатура	= Запись.Номенклатура; 
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Номенклатура	= Структура.Номенклатура; 
				КонецЕсли; 
				 	
				Если ЗначениеЗаполнено(Запись.Машина)  Тогда 
					ЗаписьВРегистреСведений.Машина			= Запись.Машина;
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Машина			= Структура.Машина; 
				КонецЕсли; 
			
			ЗаписьВРегистреСведений.Записать();
		// -- Записываем в регистр бонус + Тест
		// -- Если индкод не прошел конвеер разрешать записывать бонусы 
			Возврат;
		КонецЕсли; 
		
		
		// ++ Если Это новый инкод разрешать записывать бонусы
		Если  ЗаписьВРегистреСведений.Количество() = 0 И  Запись.ЭтоНовыйИндКод = ИСТИНА Тогда 
			ЗаписьВРегистреСведений 					= РегистрыСведений.БонусыУчетчикиРазборщики.СоздатьМенеджерЗаписи();
				Если Запись.Ответственный 				<> Справочники.Пользователи.ПустаяСсылка() Тогда 
					ЗаписьВРегистреСведений.Сотрудник	= Запись.Ответственный; 
				Иначе 
					ИмяТекПользователя 					= ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя;  
					СсылкаТекПользователя 				= Справочники.Пользователи.НайтиПоНаименованию(ИмяТекПользователя);    
					ЗаписьВРегистреСведений.Сотрудник	= СсылкаТекПользователя;
				КонецЕсли; 	
			ЗаписьВРегистреСведений.ИндКод 			= Запись.индкод;
			ЗаписьВРегистреСведений.Цена			= Запись.Цена;
			ЗаписьВРегистреСведений.Бонус			= ЗаписьВРегистреСведений.Цена * 0.005; 
			ЗаписьВРегистреСведений.Период			= ТекущаяДата(); 
				
				Если ЗначениеЗаполнено(Запись.Номенклатура) И ЗначениеЗаполнено(Запись.Машина)  Тогда 
					ЗаписьВРегистреСведений.Номенклатура	= Запись.Номенклатура; 
					ЗаписьВРегистреСведений.Машина			= Запись.Машина;
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Номенклатура	= Структура.Номенклатура; 
					ЗаписьВРегистреСведений.Машина			= Структура.Машина;
				КонецЕсли; 
				
				Если ЗначениеЗаполнено(Запись.Номенклатура)  Тогда 
					ЗаписьВРегистреСведений.Номенклатура	= Запись.Номенклатура; 
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Номенклатура	= Структура.Номенклатура; 
				КонецЕсли; 
				 	
				Если ЗначениеЗаполнено(Запись.Машина)  Тогда 
					ЗаписьВРегистреСведений.Машина			= Запись.Машина;
				Иначе 
					Структура = ПолучитьНоменклатуруИМашину(Запись.индкод);
					ЗаписьВРегистреСведений.Машина			= Структура.Машина; 
				КонецЕсли; 
			
			ЗаписьВРегистреСведений.Записать();
		
		КонецЕсли;
		// -- Если Это новый инкод разрешать записывать бонусы
	
	КонецЕсли; 
	
КонецПроцедуры
&НаСервере
Функция ПолучитьНоменклатуруИМашину (ИНдНомер)

Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрНакопления1Остатки.Товар,
	|	РегистрНакопления1Остатки.машина
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|ГДЕ
	|	РегистрНакопления1Остатки.индкод = &индкод";

Запрос.УстановитьПараметр("индкод", ИНдНомер);

РезультатЗапроса = Запрос.Выполнить();

ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Структура = Новый Структура; 
Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Структура.Вставить("Машина",ВыборкаДетальныеЗаписи.машина);
	Структура.Вставить("Номенклатура",ВыборкаДетальныеЗаписи.Товар);
КонецЦикла;

Возврат Структура; 

КонецФункции

Функция ПроверкаПользователя()
	
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.МестоРаботы КАК МестоРаботы
	               |ПОМЕСТИТЬ ВТ_МестоРаботы
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |ГДЕ
	               |	Сотрудники.Пользователь = &Пользователь
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	РегистрНакопления1Остатки.Склад.Город КАК СкладГород,
	               |	ВТ_МестоРаботы.МестоРаботы КАК МестоРаботы
	               |ИЗ
	               |	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки,
	               |	ВТ_МестоРаботы КАК ВТ_МестоРаботы
	               |ГДЕ
	               |	РегистрНакопления1Остатки.индкод = &индкод";
	Запрос.УстановитьПараметр("Пользователь",Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("индкод",Запись.индкод);
	Выборка = запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если выборка.МестоРаботы.наименование <> выборка.СкладГород.наименование Тогда
		Возврат Ложь;
	Иначе
		возврат Истина;
	КонецЕсли;
	

КонецФункции


Функция ПечатьэтикеткиСерв(Ссылка)
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = Справочники.Номенклатура.ПолучитьМакет("Этикетка");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИндКодc.Наименование КАК Наименование,
	|	ИндКодc.Владелец КАК Владелец,
	|	ВЫРАЗИТЬ(ИндКодc.Владелец.Наименование КАК СТРОКА(39)) КАК Название,
	|	ИндКодc.Владелец.МестоНаСкладе2 КАК ВладелецМестоНаСкладе2,
	|	ИндКодc.Владелец.Бренд КАК Бренд,
	|	ИндКодc.Владелец.НомерПроизводителя КАК НомерПроизводителя,
	|	ИндКодc.Владелец.Производитель КАК Производитель,
	|	ИндНомер.Стеллаж КАК Стеллаж
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИндКод КАК ИндКодc
	|		ПО ИндНомер.индкод = ИндКодc.Ссылка
	|ГДЕ
	|	ИндНомер.индкод = &Ссылка";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШтрихКод");
	ТабДок.Очистить();  
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(""); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УровеньКоррекцииQR = 3;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = Строка(Ссылка);
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	ФайлКартинки 			             = КартинкаШтрихКод;
	ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаШтрихКод;
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		ОбластьМакета.Параметры.Название = Выборка.Название;
		ОбластьМакета.Параметры.Код = Выборка.Наименование;
		//ОбластьМакета.Параметры.Место = Выборка.Стеллаж;
	КонецЦикла;   
	//Запись.Поддон = Справочники.Поддоны.ПустаяСсылка();
	//Запись.Стеллаж = Справочники.Стеллаж.НайтиПоКоду("000001072");
	ТабДок.АвтоМасштаб = Истина; 
	ТабДок.Вывести(ОбластьМакета);
	Возврат табдок; 
	
КонецФункции

&НаКлиенте
Процедура ПоддонПриИзменении(Элемент)
	сменаПолки(); 
	Событие = "Сменил поддон на: " + запись.Поддон;
	ЗаписьЛога(Событие, ТекущаяДата());
КонецПроцедуры   

&НаСервере
процедура сменаПолки()
	Если запись.Поддон.владелец <>Справочники.Стеллаж.ПустаяСсылка() Тогда
		запись.Стеллаж = запись.Поддон.стеллаж; 
	КонецЕсли;
КонецПроцедуры 




Процедура ЗаписьЛога(Событие, Дата)
	
	ТекстЛога =  "----------------------------------------------------" + Символы.ПС + Дата + Символы.ПС + Пользователи.ТекущийПользователь() + Символы.ПС +" "+ Событие + Символы.ПС ;
	
	ЗаписьЛога = РегистрыСведений.ЛогИндНомера.СоздатьМенеджерЗаписи();
	ЗаписьЛога.индкод 		 = запись.индкод;
	ЗаписьЛога.Дата 		 = Дата;
	ЗаписьЛога.Период 		 = Дата;
	ЗаписьЛога.Текст         = ТекстЛога;
	ЗаписьЛога.Записать();
	ВыводЛога();	
КонецПроцедуры     

Процедура ВыводЛога()
	
	НаборЛогов = "";
	Запрос = Новый запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ЛогИндНомера.Текст КАК Текст,
	                |	ЛогИндНомера.Период КАК Период
	                |ИЗ
	                |	РегистрСведений.ЛогИндНомера КАК ЛогИндНомера
	                |ГДЕ
	                |	ЛогИндНомера.индкод = &индкод";
	Запрос.УстановитьПараметр("индкод", запись.индкод);
	
	Логи = Запрос.Выполнить().Выбрать();
	
	Пока Логи.Следующий() Цикл
		Текст = СтрЗаменить(Логи.Текст,Строка(Логи.Период),"");
		НаборЛогов = НаборЛогов + Строка(Логи.Период) + Текст;
	КонецЦикла;
	Лог = НаборЛогов;
КонецПроцедуры

&НаКлиенте
Процедура СтеллажПриИзменении(Элемент)
	Событие = "Сменил стеллаж на: " + запись.Стеллаж;
	ЗаписьЛога(Событие, ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	Событие = "Сменил состояние на: " + запись.Состояние;
	ЗаписьЛога(Событие, ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	///+ГомзМА 13.12.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава")) ИЛИ
		ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) Тогда
		
		Элементы.ЕстьФото.Видимость = Истина;
	Иначе
		Элементы.ЕстьФото.Видимость = Ложь;
	КонецЕсли;
	///-ГомзМА 13.12.2023
	
КонецПроцедуры


&НаКлиенте
Процедура ПечатьСПросмотром(Команда)
	
	//Волков ИО Наряд 000005347 16.02.24 ++ 
		//Запись.АвитоЧастник = Истина;
		//Если ПроверкаИндКода() > 1 и НЕ ПроверкаВладельца() Тогда
		//	Сообщить("Стоп! На один Инд. код можно учесть только ОДНУ деталь.");
		//	Запись.АвитоЧастник = Ложь;
		//	Возврат;
		//	//Прервать;
		//КонецЕсли;
		//
		//Если Запись.АвитоЧастник Тогда
		//	запись.ДатаИзмененияКонвеера = ТекущаяДата();
		//	запись.Ответственный = НашПользователь();
		//	АвитоЧастникПриИзмененииНаСервере();
		//КонецЕсли; 
	//Волков ИО Наряд 000005347 16.02.24 -- 
	 
	//Волков ИО Наряд 000005347 16.02.24 ++ 
		///+ГомзМА 13.12.2023
		//Событие = "Установил галочку " + Элементы.АвитоЧастник.Заголовок;
		//ЗаписьЛога(Событие, ТекущаяДата());
		//
		//Событие = "Сменил цену на: " + запись.Цена;
		//ЗаписьЛога(Событие, ТекущаяДата() + 1);
		//
		//Событие = "Сменил стеллаж на: " + запись.Стеллаж;
		//ЗаписьЛога(Событие, ТекущаяДата() + 2);
		//
		//Событие = "Сменил состояние на: " + запись.Состояние;
		//ЗаписьЛога(Событие, ТекущаяДата() + 3);
	//Волков ИО Наряд 000005347 16.02.24 -- 
	
	ТабДок = ПечатьэтикеткиСерв(запись.индкод);
	
	//ТабДок.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьэтикеткиСерв");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьэтикеткиСерв";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	
	///+ГомзМА 13.12.2023
	Событие = "Распечатал бирку";
	ЗаписьЛога(Событие, ТекущаяДата());
	///-ГомзМА 13.12.2023
	
	
КонецПроцедуры


Функция ПолучитьМенеджеровПоПродаже()
	
	///+ГомзМА 27.05.2024
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПриказ.Сотрудник КАК Сотрудник,
		|	МАКСИМУМ(КадровыйПриказ.Дата) КАК ДатаДоговора
		|ПОМЕСТИТЬ ВТ_ДолжностиДаты
		|ИЗ
		|	Документ.КадровыйПриказ КАК КадровыйПриказ
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПриказ.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(КадровыйПриказ.Должность) КАК Должность,
		|	МАКСИМУМ(КадровыйПриказ.Отдел) КАК Отдел,
		|	КадровыйПриказ.Сотрудник КАК Сотрудник,
		|	МАКСИМУМ(КадровыйПриказ.Дата) КАК ДатаДоговора
		|ПОМЕСТИТЬ ВТ_ДолжностиНовые
		|ИЗ
		|	Документ.КадровыйПриказ КАК КадровыйПриказ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДолжностиДаты КАК ВТ_ДолжностиДаты
		|		ПО (ВТ_ДолжностиДаты.Сотрудник = КадровыйПриказ.Сотрудник)
		|		И (ВТ_ДолжностиДаты.ДатаДоговора = КадровыйПриказ.Дата)
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПриказ.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Сотрудники.Наименование КАК Наименование,
		|	Сотрудники.Код КАК Код,
		|	Сотрудники.Ссылка КАК Ссылка,
		|	Сотрудники.ДатаРождения КАК ДатаРождения,
		|	Сотрудники.Руководитель КАК Руководитель,
		|	Подразделения.Ссылка КАК ОтделНов,
		|	ВТ_ДолжностиНовые.Должность КАК ДолжностьНов,
		|	Сотрудники.Пользователь КАК Пользователь
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДолжностиНовые КАК ВТ_ДолжностиНовые
		|		ПО (ВТ_ДолжностиНовые.Сотрудник = Сотрудники.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Подразделения КАК Подразделения
		|		ПО (Подразделения.Участники.Сотрудник = Сотрудники.Пользователь)
		|ГДЕ
		|	НЕ Сотрудники.Пользователь.Недействителен
		|	И ВТ_ДолжностиНовые.Должность.Наименование ПОДОБНО &НаименованиеДолжности
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОтделНов,
		|	Наименование";
	
	Запрос.УстановитьПараметр("НаименованиеДолжности", "%Менеджер по продажам%");
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	МассивМенеджеров = Новый Массив;
	Пока РезультатЗапроса.Следующий() Цикл
		МассивМенеджеров.Добавить(РезультатЗапроса.Пользователь);
	КонецЦикла;
	
	Возврат МассивМенеджеров;
	///-ГомзМА 27.05.2024
	
	
КонецФункции


Функция ПроверитьМенеджера(Менеджер)
	
	///+ГомзМА 27.05.2024
	Результат = Ложь;
	
	МассивРазрешенныхМенеджеров = Новый Массив;
	//ЕКБ
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Ягофаров Николай Дмитриевич"));
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Овчинников Вячеслав Георгиевич"));
	//МСК
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Платунов Сергей Викторович"));
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Карпычев Антон Андреевич"));
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Яблоков Александр Анатольевич"));
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Урунов Муминджон Мойдинович"));
	МассивРазрешенныхМенеджеров.Добавить(Справочники.Пользователи.НайтиПоНаименованию("Саидов Мирзошариф Джумаевич"));
	
	Если МассивРазрешенныхМенеджеров.Найти(Менеджер) <> Неопределено Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	///-ГомзМА 27.05.2024
	
КонецФункции