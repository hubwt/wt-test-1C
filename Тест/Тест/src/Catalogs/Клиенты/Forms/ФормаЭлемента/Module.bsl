&НаКлиенте
Перем Кэш;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыДлительнойОперации = Новый Структура("Завершено, АдресРезультата, Идентификатор, Ошибка, ПодробноеПредставлениеОшибки");
	
	ПараметрыДлительнойОперации.Вставить("ИнтервалОжидания", 5);
	
	
	ПодготовитьСписокПродажи();
	ОбновитьСписки(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
	
	
	Если Параметры.Свойство("КлиентНаименование") Тогда
		объект.Телефон = параметры.НомерТелефона;
		объект.Ответственный = параметры.Ответственный;
		объект.Наименование = параметры.КлиентНаименование;
	КонецЕсли;
	
	//маска телефона
	Если Не ЗначениеЗаполнено(Объект.Телефон) И ИностранныйНомер = Ложь Тогда
		Элементы.Телефон.Маска = "+7 ### ###-##-##";
	КонецЕсли;
	
	
	Если Параметры.Свойство("ТекущаяВкладка") Тогда
		Если Параметры.ТекущаяВкладка = "КонтактныеЛица" Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаКонтактныеЛица;
			
			Если Параметры.Свойство("КонтактноеЛицо") Тогда
				СтрокиТаблицы = Объект.ДополнительныеКонтакты.НайтиСтроки(Новый Структура("ФИО", Параметры.КонтактноеЛицо));
				Если СтрокиТаблицы.Количество() <> 0 Тогда
					Элементы.ДополнительныеКонтакты.ТекущаяСтрока = СтрокиТаблицы[0].ПолучитьИдентификатор();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ВидимостьПоЦелевому();
	
	///+ГомзМА 27.12.2022 
	//Ограничение редактирования флажка "Дилер"
	Если НЕ	ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) И 
		НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Руководитель")) Тогда
		
		Элементы.Дилер.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	//Ограничение редактирования флажка "Дилер" кроме Чувилева И Романова
	/// Комлев 02/07/24 +++
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя = "Чувилёв Михаил Александрович" ИЛИ  
		ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя = "Романов Игорь Леонидович" Тогда
		
		Элементы.Дилер.ТолькоПросмотр = Ложь;
		
	КонецЕсли;
	
	/// Комлев 02/07/24 ---
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) Тогда
		
		Элементы.ПроверкаИНН.Видимость = Истина;
		
	КонецЕсли;
	///-ГомзМА 27.12.22 
	
	
	//Если Параметры.Ключ.Пустая() Тогда
	//	
	
	//Иначе
	//	Если объект.Ответственный <> Пользователи.ТекущийПользователь() 
	//		И не(  Пользователи.РолиДоступны("Руководитель") ИЛИ  Пользователи.РолиДоступны("ТекстовыйМенеджер")) Тогда
	//		ЭтаФорма.ТолькоПросмотр = Истина;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	///+ГомзМА 17.02.2023 (Задача 000002741 от 16.02.2023)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказКлиента.Ссылка КАК Документ,
	|	ЗаказКлиента.Дата КАК Дата,
	|	ЗаказКлиента.Номер КАК Номер,
	|	ЗаказКлиента.Состояние КАК Состояние,
	|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Клиент = &Клиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Клиент", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
		Пока РезультатЗапроса.Следующий() Цикл
			Объект.ДатаПоследнейЗаявки = РезультатЗапроса.Дата;
			Объект.НомерПоследнейЗаявки = РезультатЗапроса.Номер;
			Объект.СостояниеПоследнейЗаявки = РезультатЗапроса.Состояние;
			Объект.СуммаПоследнейЗаявки = РезультатЗапроса.СуммаДокумента;
		КонецЦикла;
	КонецЕсли;
	///+ГомзМА 17.02.2023 (Задача 000002741 от 16.02.2023)
	
	СписокЗаявки.Параметры.УстановитьЗначениеПараметра("Клиент", Объект.Ссылка);
	звонки.Параметры.УстановитьЗначениеПараметра("Клиент", Объект.Ссылка);
	Массивтелефонов = новый Массив;
	Массивтелефонов.Добавить(Объект.Телефон);
	Для каждого стр из объект.ДополнительныеКонтакты Цикл
		Массивтелефонов.Добавить(стр.Телефон);
	КонецЦикла;
	
	звонки.Параметры.УстановитьЗначениеПараметра("НомерТелефона", Массивтелефонов);
	
	ОбновитьСчетчикКонтролера();
	
	ЗаполнитьСписокКовбоев();
	
КонецПроцедуры 

Процедура ЗаполнитьСписокКовбоев() 
	элементы.КовбойМальборо.СписокВыбора.Очистить();
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000001"));
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000178"));
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000029"));
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000018"));
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000065")); 
	элементы.КовбойМальборо.СписокВыбора.Добавить(получитьКовбоя("000000100"));

КонецПроцедуры

Функция получитьКовбоя(код) 
Возврат Справочники.Сотрудники.НайтиПоКоду(код).Пользователь;	
КонецФункции

//Волков ОИ 07.12.23 ++
Функция ВычислитьОстатокПоКлиенту()//(Баланс)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ первые 1
	|	БалансКлиентаОстатки.БалансОстаток КАК БалансОстаток
	|ИЗ
	|	РегистрНакопления.БалансКлиента.Остатки(&МоментВремени, ) КАК БалансКлиентаОстатки
	|ГДЕ
	|	БалансКлиентаОстатки.Клиент = &Клиент";
	
	Запрос.УстановитьПараметр("МоментВремени", ТекущаяДата());
	Запрос.УстановитьПараметр("Клиент", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	///+ГомзМА 24.01.2024
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();			
		Баланс = Выборка.БалансОстаток;
		
		Возврат Баланс;		
	Иначе
		Возврат 0;
	КонецЕсли;
	///-ГомзМА 24.01.2024
	
	Т = 1;
	
КонецФункции
//Волков ИО 07.12.23 --

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	///+ГомзМА 24.01.2024
	ПриОткрытииНаСервере();
	///-ГомзМА 24.01.2024
	
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()

	//Волков ИО 07.12.23 ++
	//Баланс = 0;
	Объект.Счет = ВычислитьОстатокПоКлиенту();//(Баланс);
	
	//Волков ИО 07.12.23 --

КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьСписки(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбновитьСписки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПрерватьФоновоеЗадание();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.ГруппаЗвонки Тогда
		
		ЗаданиеВыполнялосьРанее = ЗначениеЗаполнено(ПараметрыДлительнойОперации.Идентификатор);
		
		Если ЗаданиеВыполнялосьРанее  Тогда
			Возврат
		КонецЕсли;
		
		ЗаданиеВыполнено = ЗапуститьПолучениеЗвонковНаСервере();
		
		Если НЕ ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Получение списка звонков...");
			ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", 0.1, Истина);
		Иначе
			
			ЗагрузитьПолученныеЗвонки();
			
		КонецЕсли;
		//	ЗаполнитьЗвонки();
	КонецЕсли;
	
	Если ТекущаяСтраница = Элементы.ГруппаЗаявки Тогда
		СписокЗаявки.Параметры.УстановитьЗначениеПараметра("Клиент",Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры




&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	
	Если Кэш <> Неопределено И Кэш.Свойство("ФайлыЗвонков") Тогда
		
		ФайлыКУдалению = Новый Массив;
		
		Для Каждого ОписаниеФайла Из Кэш.ФайлыЗвонков Цикл
			ФайлыКУдалению.Добавить(ОписаниеФайла.Значение);
		КонецЦикла;
		
		Попытка
			УдалитьФайлы(ФайлыКУдалению);
		Исключение
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ЧастноеЛицоПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипКлиентаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_АвтомобилиКлиента

&НаКлиенте
Процедура АвтомобилиКлиентаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Не ЭтаФорма.Записать();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрослушатьЗаписьЗвонка(Команда)
	Если Элементы.Звонки.ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если Кэш = Неопределено Тогда
		Кэш = Новый Структура();
		Кэш.Вставить("ФайлыЗвонков", Новый Соответствие());
	КонецЕсли;
	
	СсылкаНаФайл = Элементы.Звонки.ТекущиеДанные.URL;
	СсылкаНаФайлЛокальная = Кэш.ФайлыЗвонков.Получить(СсылкаНаФайл);
	
	Если СсылкаНаФайлЛокальная = Неопределено Тогда
		
		СсылкаНаФайлЛокальная = дт_МоиЗвонкиКлиент.ПолучитьФайлЗаписи(СсылкаНаФайл);
		Если СсылкаНаФайлЛокальная = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		Кэш.ФайлыЗвонков.Вставить(СсылкаНаФайл, СсылкаНаФайлЛокальная);
		
	КонецЕсли;
	дт_МоиЗвонкиКлиент.ПрослушатьФайл(СсылкаНаФайлЛокальная);	  
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если Объект.ЧастноеЛицо = Истина Тогда
		Элементы.Группа4.Видимость = Истина;
		Элементы.Группа3.Видимость = Ложь;
	Иначе
		Элементы.Группа4.Видимость = Ложь;
		Элементы.Группа3.Видимость = Истина;
	КонецЕсли;
	
	
	
	ТипКлиентаИП = ОбщегоНазначенияУТКЛиентСервер.ЭтоИП(Объект.ТипКлиента);
	ТипКлиентаФизлицо  = ОбщегоНазначенияУТКЛиентСервер.ЭтоФизлицо(Объект.ТипКлиента);
	ТипКлиентаЮрлицо  = ОбщегоНазначенияУТКЛиентСервер.ЭтоЮрЛицо(Объект.ТипКлиента);
	
	ТипКлиентаЧастноеЛицо =  ОбщегоНазначенияУТКЛиентСервер.ЭтоЧастноеЛицо(Объект.ТипКлиента);
	ТипКлиентаБизнес = ОбщегоНазначенияУТКЛиентСервер.ЭтоБизнесКлиент(Объект.ТипКлиента);
	
	Элементы.ГруппаИНН_КПП.Видимость = ТипКлиентаБизнес;
	Элементы.Фамилия.Видимость = ТипКлиентаЧастноеЛицо;
	Элементы.КлиентПолноеНаименование.Видимость = ТипКлиентаЮрлицо;
	Элементы.ГруппаКоды.Видимость = ТипКлиентаБизнес;
	Элементы.ГруппаПаспорт.Видимость = ТипКлиентаЧастноеЛицо;
	Элементы.РуководительФИО.Видимость = ТипКлиентаЮрлицо;
	
	// заголовки
	Элементы.ЮридическийАдрес.Заголовок = ?(ТипКлиентаФизлицо, "Адрес по прописке", "Юридический адрес");
	
	Элементы.ОсновнойДоговор.Видимость = ЗначениеЗаполнено(Объект.Ссылка);
	
	Элементы.ГруппаЗвонки.Видимость = Форма.ПолучитьФункциональнуюОпциюФормы("дт_ИспользоватьИнтеграциюМоиЗвонки")
	И дт_МоиЗвонкиВызовСервера.ДоступнаПодсистема();
	
	Элементы.АвтомобилиКлиентаГруппаДетально.Видимость = Форма.ПолучитьФункциональнуюОпциюФормы("дт_ИспользоватьАвтосервис");
	
КонецПроцедуры // УправлениеФормой()


&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписки(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Форма.АвтомобилиКлиента, 
	"Владелец", 
	Форма.Объект.Ссылка, 
	ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Форма.Продажи, 
	"Клиент", 
	Форма.Объект.Ссылка, 
	ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьСписокПродажи() 
	// Сергеев +000003849
	ТекстЗапроса = ТекстЗапросаПродажи();
	Продажи.ТекстЗапроса = ТекстЗапроса;			
	Продажи.ОсновнаяТаблица = ИмяОсновнойТаблицы(ТекстЗапроса);
	Элементы.Продажи.Обновить();
	
	запрос = Новый запрос;
	Запрос.текст = ТекстЗапросаПродажи();
	Запрос.УстановитьПараметр("Клиент", объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выгрузить();
	Если выборка.Количество() > 0 Тогда
		индекс = 0;
		Суммаинтервалов = 0;
		выборка.Колонки.Добавить("Период",Новый ОписаниеТипов("Число"),"Период",);
		выборка.Колонки.Добавить("Порядок",Новый ОписаниеТипов("Число"),"Порядок",);
		Для каждого стр из выборка Цикл
			Стр.Порядок  = Индекс+1;
			Если индекс = 0 тогда	
				индекс = 1;
				Продолжить;
			Иначе
				Стр.Период = (НачалоДня(Стр.Дата) - НачалоДня(выборка[индекс-1].Дата)) / (60 * 60 * 24);
				индекс 	   = индекс +1;
				Суммаинтервалов = Суммаинтервалов + Стр.Период; 
				Если Индекс = выборка.Количество() тогда
					СпоследнейПродажи = (НачалоДня(ТекущаяДата()) - НачалоДня(Стр.Дата)) / (60 * 60 * 24);
					СреднийИнтервалЗакупа = Суммаинтервалов/выборка.Количество(); 
				Иначе
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		АнализПродаж.Загрузить(Выборка);
		//		
	КонецЕсли;
	// Сергеев -000003849
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяОсновнойТаблицы(ТекстЗапроса)
	
	Инд = СтрНайти(ТекстЗапроса, "ИЗ");
	Фрагмент = Сред(ТекстЗапроса, Инд + 2);
	Инд = СтрНайти(Фрагмент, "КАК");
	Фрагмент = Лев(Фрагмент, Инд - 1); 	
	Фрагмент = СтрЗаменить(Фрагмент, " ", "");
	Фрагмент = СтрЗаменить(Фрагмент, Символы.ПС, "");
	Фрагмент = СтрЗаменить(Фрагмент, Символы.Таб, "");
	
	Возврат Фрагмент;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаПродажи()
	
	Если ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис")
		И ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку") Тогда
		
		Результат =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Продажи.Дата КАК Дата,
		|	Продажи.Номер КАК Номер,
		|	Продажи.Ссылка КАК Ссылка,
		|	Продажи.Клиент КАК Клиент,
		|	Продажи.Ответственный КАК Ответственный,
		|	Продажи.Сумма КАК Сумма,
		|	ЕСТЬNULL(ОплатыПоСделкамОбороты.СуммаОборот, 0) >= Продажи.Сумма КАК Оплачено,
		|	Продажи.Комментарий КАК Комментарий,
		|	Продажи.Тип КАК Тип,
		|	Продажи.Организация КАК Организация
		|ИЗ
		|	ЖурналДокументов.Продажи КАК Продажи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОплатыПоСделкам.Обороты КАК ОплатыПоСделкамОбороты
		|		ПО ОплатыПоСделкамОбороты.Документ = Продажи.Ссылка";
		
	ИначеЕсли ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис") Тогда
		
		Результат =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Док.Дата КАК Дата,
		|	Док.Номер КАК Номер,
		|	Док.Ссылка КАК Ссылка,
		|	Док.Клиент КАК Клиент,
		|	Док.Ответственный КАК Ответственный,
		|	Док.СуммаДокумента КАК Сумма,
		|	ЕСТЬNULL(ОплатыПоСделкамОбороты.СуммаОборот, 0) >= Док.СуммаДокумента КАК Оплачено,
		|	Док.Комментарий КАК Комментарий,
		|	ТИПЗНАЧЕНИЯ(Док.Ссылка) КАК Тип,
		|	Док.Организация КАК Организация
		|ИЗ
		|	Документ.ЗаказНаряд КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОплатыПоСделкам.Обороты КАК ОплатыПоСделкамОбороты
		|		ПО ОплатыПоСделкамОбороты.Документ = Док.Ссылка";
	Иначе
		Результат =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Док.Ссылка КАК Ссылка,
		|	Док.Номер КАК Номер,
		|	Док.Дата КАК Дата,
		|	Док.Клиент КАК Клиент,
		|	Док.КтоПродал КАК Ответственный,
		|	Док.ИтогоРекв КАК Сумма,
		|	ЕСТЬNULL(ОплатыПоСделкамОбороты.СуммаОборот, 0) >= Док.ИтогоРекв КАК Оплачено,
		|	Док.Комментарий КАК Комментарий,
		|	ТИПЗНАЧЕНИЯ(Док.Ссылка) КАК Тип,
		|	Док.Организация КАК Организация
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОплатыПоСделкам.Обороты КАК ОплатыПоСделкамОбороты
		|		ПО (ОплатыПоСделкамОбороты.Документ = Док.Ссылка)
		|ГДЕ
		|	Док.Клиент = &Клиент
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
		
	КонецЕсли;
	Возврат Результат;
КонецФункции


&НаСервере
Функция ЗапуститьПолучениеЗвонковНаСервере()
	
	Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьИнтеграциюМоиЗвонки") 
		ИЛИ НЕ  ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Возврат Истина;
		
	КонецЕсли;	
	
	Если НЕ ПараметрыДлительнойОперации.Идентификатор = Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ПараметрыДлительнойОперации.Идентификатор);
	КонецЕсли;
	
	
	ПараметрыДлительнойОперации.Идентификатор   = Неопределено;
	ПараметрыДлительнойОперации.Завершено       = Истина;
	ПараметрыДлительнойОперации.АдресРезультата = Неопределено;
	ПараметрыДлительнойОперации.Ошибка          = Неопределено;
	
	//ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("Ссылка", Объект.Ссылка);
	
	НаименованиеМетода = НСтр("ru = 'Заполнение списка звонков'");
	
	Попытка
		
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"дт_МоиЗвонки.ЗапуститьПолучениеТаблицыЗвонковПоКлиенту",
		ПараметрыМетода,
		НаименованиеМетода);
		
		
	Исключение
		
		ПараметрыДлительнойОперации.Ошибка = ОписаниеОшибки();
		
		Возврат Ложь;
	КонецПопытки;
	
	
	ПараметрыДлительнойОперации.Идентификатор   = РезультатВыполнения.ИдентификаторЗадания;
	ПараметрыДлительнойОперации.Завершено       = РезультатВыполнения.ЗаданиеВыполнено;
	ПараметрыДлительнойОперации.АдресРезультата = РезультатВыполнения.АдресХранилища;
	
	Возврат РезультатВыполнения.ЗаданиеВыполнено;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьПолученныеЗвонки()
	
	ЗагрузитьПолученныеЗвонкиСервер();
	ПоказатьОповещениеПользователя("Список звонков получен");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПолученныеЗвонкиСервер()
	
	ТаблицаЗвонки.Очистить();
	
	Если ПараметрыДлительнойОперации.АдресРезультата = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(ПараметрыДлительнойОперации.АдресРезультата);
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		
		ТаблицаРезультат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "ТаблицаРезультат");
		
		Если ТаблицаРезультат <> Неопределено Тогда
			ТаблицаЗвонки.Загрузить(ТаблицаРезультат);
			ТаблицаЗвонки.Сортировать("Дата Убыв");
			
			Если объект.ДатаПоследнегоКонтакта < ТаблицаЗвонки[0].Дата тогда
				объект.ДатаПоследнегоКонтакта = ТаблицаЗвонки[0].Дата;
			КонецЕсли;
			
		КонецЕсли;
		
		
		ДатаПоследнейПродажи = датаПоследнейПродажи();
		
		Если объект.ДатаПоследнегоКонтакта < ДатаПоследнейПродажи  тогда
			объект.ДатаПоследнегоКонтакта = ДатаПоследнейПродажи;
		КонецЕсли;
		
	КонецЕсли;
	
	//	Если НЕ ПустаяСтрока(РезультатВыполнения.ТекстОшибки) Тогда
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатВыполнения.ТекстОшибки);
	//	КонецЕсли;
	
	
КонецПроцедуры

Функция датаПоследнейПродажи()
	Запрос = новый запрос;
	Запрос.Текст ="ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПродажиЗапчастей.Дата КАК ДатаПродажи
	|ИЗ
	|	Документ.ПродажаЗапчастей КАК ПродажиЗапчастей
	|ГДЕ
	|	ПродажиЗапчастей.Клиент = &Клиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПродажи УБЫВ";
	Запрос.УстановитьПараметр("Клиент",Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Возврат Выборка.ДатаПродажи;
	Иначе
		Возврат Объект.ДатаПоследнегоКонтакта;
	КонецЕсли;
	
	
КонецФункции


&НаСервере
Функция СостояниеФоновогоЗадания()
	Результат = Новый Структура("Прогресс, Завершено, Ошибка, ПодробноеПредставлениеОшибки");
	
	Результат.Ошибка = "";
	Если ПараметрыДлительнойОперации.Идентификатор = Неопределено Тогда
		Результат.Завершено = Истина;
		Результат.Прогресс  = Неопределено;
		Результат.ПодробноеПредставлениеОшибки = ПараметрыДлительнойОперации.ПодробноеПредставлениеОшибки;
		Результат.Ошибка                       = ПараметрыДлительнойОперации.Ошибка;
	Иначе
		Попытка
			Результат.Завершено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыДлительнойОперации.Идентификатор);
			Результат.Прогресс  = ДлительныеОперации.ПрочитатьПрогресс(ПараметрыДлительнойОперации.Идентификатор);
		Исключение
			Информация = ИнформацияОбОшибке();
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Информация);
			Результат.Ошибка                       = КраткоеПредставлениеОшибки(Информация);
		КонецПопытки
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОжиданиеДлительнойОперации()
	
	// Обновим статус
	Состояние = СостояниеФоновогоЗадания();
	Если Не ПустаяСтрока(Состояние.Ошибка) Тогда
		// Завершено с ошибкой, сообщим и вернемся на первую страницу.
		//Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		//Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Состояние.Ошибка);
		Возврат;
		
	ИначеЕсли Состояние.Завершено Тогда
		//ПодтверждениеЗакрытияФормы = Истина;
		ЗагрузитьПолученныеЗвонки();
		
		Возврат;
		
	КонецЕсли;
	
	// Процесс продолжается
	Если ТипЗнч(Состояние.Прогресс) = Тип("Структура") Тогда
		
		ТекстПрогресса = Состояние.Прогресс.Текст;
		ИндикаторПрогресса = Состояние.Прогресс.Процент;
		
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", ПараметрыДлительнойОперации.ИнтервалОжидания, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	
	Если ПараметрыДлительнойОперации.Идентификатор <> Неопределено Тогда
		
		ПрерватьФоновоеЗаданиеСервер(ПараметрыДлительнойОперации.Идентификатор);
		ПараметрыДлительнойОперации.Идентификатор = Неопределено;
		
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации");
	
	//УстановитьВидимость(Ложь);
	
КонецПроцедуры // ПрерватьФоновоеЗадание()


&НаСервереБезКонтекста
Процедура ПрерватьФоновоеЗаданиеСервер(Знач Идентификатор)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(Идентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(строка(объект.Телефон));
	
	ФоновыеЗадания.Выполнить("МоиЗвонкиИЗаявки.ПолучитьТаблицуЗвонковПоНомеруТелефонаОбр",МассивПараметров,Новый УникальныйИдентификатор);
КонецПроцедуры

&НаСервере
Процедура ВидимостьПоЦелевому()
	Если Объект.Целевой Тогда
		Элементы.СтатусКлиента.Видимость  		 = Истина;
		Элементы.СфераДеятельности.Видимость 	 = Истина;
		Элементы.РазмерКомпании.Видимость 		 = Истина;
		Элементы.ТипТехники.Видимость 			 = Истина;
		Элементы.ТипКлиента.Видимость     		 = Истина;
		Элементы.ТипАвто.Видимость        		 = Ложь;
		Элементы.МаркаАвто.Видимость      		 = Ложь;
		Элементы.Скидка.Видимость    	  		 = Истина;
		Элементы.город2.Видимость    	  		 = Истина;
		Элементы.страна2.Видимость    	  		 = Истина;
		Элементы.область.Видимость    	  		 = Истина;
		Элементы.ГруппаСтраницы.Видимость 		 = Истина;
		Элементы.ОтсрочкаПлатежаВДнях.Видимость  = Истина;
		Элементы.КоличествоАвтомобилей.Видимость = Истина;
		//Элементы.Комментарий1.Видимость          = Ложь;
	Иначе
		Элементы.ОтсрочкаПлатежаВДнях.Видимость  = Ложь;
		Элементы.КоличествоАвтомобилей.Видимость = Ложь;
		Элементы.СфераДеятельности.Видимость 	 = Ложь;
		Элементы.РазмерКомпании.Видимость 		 = Ложь;
		Элементы.ТипТехники.Видимость 			 = Ложь;
		Элементы.СтатусКлиента.Видимость  		 = Ложь;
		Элементы.ТипКлиента.Видимость     		 = Ложь;
		Элементы.ТипАвто.Видимость        		 = Истина;
		Элементы.МаркаАвто.Видимость      		 = Истина;
		Элементы.Скидка.Видимость    	  		 = Ложь;
		Элементы.город2.Видимость    	  		 = Ложь;
		Элементы.страна2.Видимость    	  		 = Ложь;
		Элементы.область.Видимость    	  		 = Ложь;
		Элементы.ГруппаСтраницы.Видимость 		 = Ложь;
		//Элементы.Комментарий1.Видимость          = Истина;
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ЦелевойПриИзменении(Элемент)
	ВидимостьПоЦелевому();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСчетчикКонтролера()
                       
	///+ГомзМА 03.10.2023
	Если Объект.ДатаПоследнегоКонтактаКонтролера <> '00010101' Тогда
		Объект.КонечнаяДатаКонтролер = Объект.ДатаПоследнегоКонтактаКонтролера + 86400 * 30;
		Объект.ОсталосьДней = Цел((Объект.КонечнаяДатаКонтролер - ТекущаяДатаСеанса()) / 86400); //+ 1);
	КонецЕсли;
	///-ГомзМА 03.10.2023

КонецПроцедуры


// ПрерватьФоновоеЗадание()

#КонецОбласти


&НаКлиенте
Процедура СоздатьДозвон(Команда)
	
	///+ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
	ТекущиеДанные = Объект;
	КоличесвтоЗаписейВМассиве = ПолучитьКоличествоДозвоновЗаТекущийГод(ТекущиеДанные);
	
	Если КоличесвтоЗаписейВМассиве > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
		
		ПоказатьВопрос(Оповещение, "Дозвон с этим номером телефона в текущем году уже существует! Создать новый?", РежимДиалогаВопрос.ДаНет);
	Иначе
		///-ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
		
		// ++ obrv 22.01.18
		//Док = СоздатьДок(Элементы.Список.ТекущаяСтрока.Код);
		Док = СоздатьДокДозвон(объект.Код);
		// -- obrv 22.01.18
		ПараметрыФормы = Новый Структура("Ключ", Док);
		ОткрытьФорму("Документ.Дозвон.ФормаОбъекта", ПараметрыФормы);
		//Док.ПолучитьФорму().ОткрытьМодально();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	///+ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
	Если Результат = КодВозвратаДиалога.Да Тогда
		Док = СоздатьДокДозвон(Объект.Код);
		ПараметрыФормы = Новый Структура("Ключ", Док);
		ОткрытьФорму("Документ.Дозвон.ФормаОбъекта", ПараметрыФормы);
	Иначе
		Возврат;
	КонецЕсли;
	///-ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоДозвоновЗаТекущийГод(ТекущиеДанные)
	
	///+ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
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
	///-ГомзМА 17.02.2023 (Задача 000002750 от 17.02.2023)
	
КонецФункции


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
Функция НайтиПользователя()
	// ++ obrv 16.01.18
	//Возврат Справочники.Пользователи.НайтиПоНаименованию(ИмяПользователя());
	Возврат ПользователиКлиентСервер.ТекущийПользователь();
	// -- obrv 16.01.18
КонецФункции


&НаКлиенте
Процедура ИностранныйНомерПриИзменении(Элемент)
	
	///+ГомзМА 14.02.2023 (Задача 000002703 от 10.02.2023)
	//маска телефона
	Если Не ЗначениеЗаполнено(Объект.Телефон) И ИностранныйНомер = Ложь Тогда
		Элементы.Телефон.Маска = "+7 ### ###-##-##";
	Иначе
		Элементы.Телефон.Маска = "";
	КонецЕсли;
	///-ГомзМА 14.02.2023 (Задача 000002703 от 10.02.2023)
	
КонецПроцедуры


&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	Объект.ДатаУстановкиОтветственного = ТекущаяДата();
КонецПроцедуры


&НаСервере
Процедура КонтролерЗвонковПриИзмененииНаСервере()
	
	///+ГомзМА 02.10.2023
	//Находим дату последнего контакта
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаписиЗвонков.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.ЗаписиЗвонков КАК ЗаписиЗвонков
		|ГДЕ
		|	ЗаписиЗвонков.Менеджер = &Менеджер
		|	И ЗаписиЗвонков.Клиент = &Клиент
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ"; 
	
	Запрос.УстановитьПараметр("Клиент", Объект.Ссылка);
	Запрос.УстановитьПараметр("Менеджер", Объект.КонтролерЗвонков.Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
		РезультатЗапроса.Следующий();
		Объект.ДатаПоследнегоКонтактаКонтролера = РезультатЗапроса.Дата;
	КонецЕсли;
	///-ГомзМА 02.10.2023
	
КонецПроцедуры


&НаКлиенте
Процедура КонтролерЗвонковПриИзменении(Элемент)
	КонтролерЗвонковПриИзмененииНаСервере();
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	///+ГомзМА 03.10.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлиентыОрганизации.Клиент КАК Клиент
		|ИЗ
		|	Справочник.Клиенты.Организации КАК КлиентыОрганизации
		|ГДЕ
		|	КлиентыОрганизации.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
		Пока РезультатЗапроса.Следующий() Цикл 
			Попытка
				ДобавитьКлиентаВоВкладуСвязанныеОрганизации(РезультатЗапроса.Клиент, Объект.Ссылка); 
			Исключение
				
			КонецПопытки;		
		КонецЦикла;
	КонецЕсли;
	///-ГомзМА 03.10.2023
	
КонецПроцедуры


&НаСервере
Процедура ДобавитьКлиентаВоВкладуСвязанныеОрганизации(Клиент, Ссылка)

	///+ГомзМА 03.10.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлиентыОрганизации.Клиент КАК Клиент
		|ИЗ
		|	Справочник.Клиенты.Организации КАК КлиентыОрганизации
		|ГДЕ
		|	КлиентыОрганизации.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Клиент);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
		КлиентЗаписан = Ложь;
		Пока РезультатЗапроса.Следующий() Цикл
			Если РезультатЗапроса.Клиент = Ссылка Тогда
				КлиентЗаписан = Истина;
			КонецЕсли;
			
			Если НЕ КлиентЗаписан Тогда
				СправочникОбъект = Клиент.ПолучитьОбъект();
				НоваяСтрока = СправочникОбъект.Организации.Добавить();
				НоваяСтрока.Клиент = Ссылка;
				СправочникОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
	Иначе
		СправочникОбъект = Клиент.ПолучитьОбъект();
		НоваяСтрока = СправочникОбъект.Организации.Добавить();
		НоваяСтрока.Клиент = Ссылка;
		СправочникОбъект.Записать();
	КонецЕсли;
	///-ГомзМА 03.10.2023

КонецПроцедуры
///МАЗИН-------------------------------------------------------НАЧАЛО


&НаКлиенте
Асинх Процедура ЗаполнитьДанныеПоИНН(Команда)
	
ИНН = Ждать ВвестиСтрокуАсинх(,"Введите ИНН",12);
	
	
	Если ИНН = Неопределено Тогда 
		Возврат;
	КонецЕсли;
Если СтрДлина (ИНН)< 10 Тогда 
	ПредупреждениеАсинх ("Некорректный ИНН.....Повторите ввод данных");
	Возврат; 
	КонецЕсли;	
	

ДанныеКлиента = ПолучитьДанныеКлиентаПоИНН (ИНН);
ЗаполнитьРеквизитыКлиента(ДанныеКлиента);

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьРеквизитыКлиента(ДанныеКлиента)

Объект.ИНН 					= ДанныеКлиента.ИНН;
Объект.КПП					= ДанныеКлиента.КПП;
Объект.ОГРН					= ДанныеКлиента.ОГРН;
Объект.ПолноеНаименование	= ДанныеКлиента.ПолноеНаименование;
Объект.ФИО					= ДанныеКлиента.Руководитель;
Объект.ЮридическийАдрес 	= ДанныеКлиента.ЮрАдресс;


КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьДанныеКлиентаПоИНН (ИНН)

	ДанныеКлиента = Новый Структура;
	ДанныеКлиента.Вставить("ИНН", ИНН);
	//https://egrul.itsoft.ru/short_data/?7730588444
	АдрессСервера = "egrul.itsoft.ru";
	АдрессРесурса = "short_data/?"+ИНН;
	 
	Соединение = Новый HTTPСоединение(АдрессСервера,,,,, 30,Новый ЗащищенноеСоединениеOpenSSL);
	Запрос = Новый HTTPЗапрос (АдрессРесурса); 
	
	Попытка 
		Ответ = Соединение.Получить(Запрос); 
	Исключение
		 Сообщение = Новый СообщениеПользователю; 
		 Сообщение.Текст = "Не удалось получить данные по ИНН" + ОписаниеОшибки();
		 Сообщение.Сообщить();
		 Возврат ДанныеКлиента;
		 КонецПопытки;
	ДанныеЕГРЛЮЛ = Неопределено; 
	ЕСли Ответ.КодСостояния=200 Тогда 
		СтрокаJSON = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеJSON = Новый ЧтениеJSON; 
		ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
		ДанныеЕГРЛЮЛ = ПрочитатьJSON(ЧтениеJSON,Истина); 
	Иначе 
		Текст = СтрШаблон("Не удалось получить данные по ИНН....
							|Код состояния: %1
							|Ответ Сервера: %2", Ответ.КодСостояния, СтрокаJSON);
	Сообщение = Новый СообщениеПользователю; 
		 Сообщение.Текст = "Текст";
		 Сообщение.Сообщить();
	Возврат ДанныеКлиента; 
	КонецЕсли;
	
	Если ДанныеЕГРЛЮЛ["short_forms"] <> Неопределено И 
	ДанныеЕГРЛЮЛ["short_forms"] = "ИП" Тогда 
	Сообщение = Новый СообщениеПользователю; 
		 Сообщение.Текст = " Данный ИНН пренадлежит ИП";
		 Сообщение.Сообщить();	  
	КонецЕсли; 
	
	ДанныеКлиента.Вставить ("ИНН",					ДанныеЕГРЛЮЛ["inn"]);
	ДанныеКлиента.Вставить ("КПП",					ДанныеЕГРЛЮЛ["kpp"]);
	ДанныеКлиента.Вставить ("ОГРН",					ДанныеЕГРЛЮЛ["ogrn"]);
	ДанныеКлиента.Вставить ("ПолноеНаименование",	ДанныеЕГРЛЮЛ["full_name"]);
	ДанныеКлиента.Вставить ("ЮрАдресс",				ДанныеЕГРЛЮЛ["address"]);
	ДанныеКлиента.Вставить ("Руководитель",			ДанныеЕГРЛЮЛ["chief"]);
	Возврат ДанныеКлиента; 
КонецФункции //()







///МАЗИН-------------------------------------------------------КОНЕЦ



&НаКлиенте
Процедура БонусыКлиентаСуммаПродажиПриИзменении1(Элемент)
	ТекДанные = Элементы.БонусыКлиента.ТекущиеДанные;

	СуммаБонусов = ТекДанные.СуммаПродажи * 0.05;
	ТекДанные.Бонусы = Цел(СуммаБонусов);
КонецПроцедуры



&НаКлиенте
Процедура БонусыКлиентаПриИзменении(Элемент)

КонецПроцедуры

&НаКлиенте
Процедура БонусыКлиентаСуммаПродажиСоздание(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Объект.ПолноеНаименование = Объект.Наименование;
КонецПроцедуры








