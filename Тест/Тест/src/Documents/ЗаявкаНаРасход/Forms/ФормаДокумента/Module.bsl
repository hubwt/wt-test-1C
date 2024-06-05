#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	ЗаполнитьСписокСогласовантов();
	ОбновитьДобавленныеКолонки();
	ОбновитьТипПолучателя();
	
	УстановитьУсловноеОформление();
	
	УправлениеФормой(ЭтаФорма);
	
	//Волков ИО 17.01.24 ++
	Элементы.Партия.Видимость = Ложь;
	//Волков ИО 17.01.24 --
	
КонецПроцедуры




&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	///+ГомзМА 26.09.2023
	УстановитьВидимостьИДоступностьЭлементов();
	///-ГомзМА 26.09.2023
	
	//Волков ИО 27.12.2023 ++
	ИзменениеЗаголовкаРеквПолучатель();	
	//Волков ИО 27.12.2023 --
	
	//Волков ИО 17.01.2024 ++
	Элементы.Партия.Видимость = Ложь;
	ВидРасходаЗакупкаЕвропа();
	//Волков ИО 17.01.2024 --
	
КонецПроцедуры


Процедура ВидРасходаЗакупкаЕвропа()
	
	Если Объект.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000042")  Тогда
		
		Элементы.Партия.Видимость = Истина;
		
	Иначе 		
		
		Элементы.Партия.Видимость = Ложь;
 	
	КонецЕсли;
	
	
КонецПроцедуры

//Волков ИО 27.12.2023 ++
Процедура ИзменениеЗаголовкаРеквПолучатель()
	
	Если Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.Зарплата Или
		 Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ДополнительныеТраты	 
	Тогда	
	
		Элементы.Получатель.Заголовок = НСтр("ru = Сотрудник");
		
	ИначеЕсли Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратЗаёмныхСредств Или
			  Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ТекущиеРасходы Или 
			  Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщикуЗапчастей Или
			  Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.КапитальныеЗатраты  
	Тогда 
	
		Элементы.Получатель.Заголовок = НСтр("ru = Поставщик");
		
	ИначеЕсли  Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю Тогда 
		
		Элементы.Получатель.Заголовок = НСтр("ru = Клиент");
		
	КонецЕсли;

КонецПроцедуры
//Волков ИО 27.12.2023 --

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры



&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьДобавленныеКолонки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
    РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами(ЭтотОбъект, Отказ, ЗавершениеРаботы, Объект.Ссылка);
КонецПроцедуры



&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	///+ГомзМА 25.09.2023
	НовыйДокумент = СоздатьДопТраты();
	
	Если НовыйДокумент <> Неопределено Тогда
		ОткрытьЗначение(НовыйДокумент);
	КонецЕсли;
	///-ГомзМА 25.09.2023

	//Волков ИО 17.01.24 ++
	ЗакупкаЕвропа = ПолучитьСпрВидыРасходовзакупкаЕвропа();
	Если Объект.ВидРасхода = ЗакупкаЕвропа И Не ЗначениеЗаполнено(Объект.Партия) Тогда  
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Установите партию";
		Сообщение.Поле = "Партия";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
		Отказ = Истина; 
	КонецЕсли;
	//Волков ИО 17.01.24 --

	
КонецПроцедуры

//Волков ИО 16.01.24 ++
Функция ПолучитьСпрВидыРасходовзакупкаЕвропа()
                                                 //ЗАКУПКА ЕВРОПА
	Возврат Справочники.ВидыРасходов.НайтиПоКоду("000000042");		
	
КонецФункции
//Волков ИО 16.01.24 --


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;	
КонецПроцедуры


&НаСервере
Процедура ДатаПриИзмененииСервер()

//	Если дт_Нумерация.ГодИзменен(Объект.Ссылка, Объект.Дата) Тогда
//		Объект.Номер = "";
//	КонецЕсли;

КонецПроцедуры // ДатаПриИзмененииСервер()

&НаКлиенте
Процедура ИнициаторПриИзменении(Элемент)
	ИнициаторПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ИнициаторПриИзмененииСервер()
	
	Если НЕ ЗначениеЗаполнено(Объект.Инициатор) Тогда
		Возврат
	КонецЕсли;
	
	КадровыеДанные = дт_Зарплата.ПолучитьКадровыеДанные(Объект.Инициатор); 
	
	Если КадровыеДанные <> Неопределено Тогда
		Объект.Подразделение = КадровыеДанные.Подразделение;
	КонецЕсли;	
			
КонецПроцедуры

&НаКлиенте
Процедура ВидРасходаПриИзменении(Элемент)
	
	ЗаполнитьСписокСогласовантов();
	ОбновитьТипПолучателя();
 
    Значение = Объект[Элемент.Имя];
    Объект[Элемент.Имя] = Элемент.ОграничениеТипа.ПривестиЗначение(Значение);
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьВидимостьИДоступностьЭлементов();
	
	//Волков ИО 17.01.24 ++
	ВидРасходаЗакупкаЕвропа();
	//Волков ИО 17.01.24 --
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	ЗаполнитьСписокСогласовантов();
	ОбновитьДобавленныеКолонки();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьТипПолучателя()

	Если Не ЗначениеЗаполнено(Объект.ВидРасхода) Тогда 
		Возврат
	КонецЕсли;
	
	СвойстваВидаРасхода = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидРасхода, "Зарплата,ВидОперацииСписаниеДенежныхСредств");
	
	Если СвойстваВидаРасхода.Зарплата
		ИЛИ СвойстваВидаРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.Зарплата Тогда
		
		ТипСтр = "СправочникСсылка.Сотрудники";
	
	Иначе
				
		ТипСтр = "СправочникСсылка.Контрагенты";
			
	КонецЕсли;
	
	Если объект.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000041") Тогда
		
		ТипСтр = "СправочникСсылка.Клиенты";
		
	КонецЕсли;
	
		
	
	Элемент = Элементы.Найти("Получатель");
	
	Если Элемент <> Неопределено Тогда
	    
	    Элемент.ОграничениеТипа = Новый ОписаниеТипов(ТипСтр);
	    Элемент.ВыбиратьТип = Ложь;	
    
    КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Товары

&НаСервереБезКонтекста
Процедура ТоварыНоменклатураПриИзмененииНаСервере(ДанныеЗаполнения)

	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Товары", "Количество");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Товары", "Цена");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Товары", "Сумма");
КонецПроцедуры






#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	
КонецПроцедуры


&НаСервере
Функция ПечатьЗаявкаНаПоступлениеНаСервере()
	
	///+ГомзМА 05.04.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ЗаявкаНаРасход.ПолучитьМакет("ЗаявкаНаПоступлениеЗапчастей");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходТовары.Номенклатура КАК Номенклатура,
	|	ЗаявкаНаРасходТовары.Товар КАК Товар,
	|	ЗаявкаНаРасходТовары.Количество КАК Количество,
	|	ЗаявкаНаРасходТовары.Цена КАК Цена,
	|	ЗаявкаНаРасходТовары.Ссылка.Дата КАК Дата,
	|	ЗаявкаНаРасходТовары.Ссылка.Ответственный КАК Ответственный,
	|	ЗаявкаНаРасходТовары.Ссылка.Получатель КАК Получатель,
	|	ЗаявкаНаРасходТовары.Ссылка.ВидРасхода КАК ВидРасхода,
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка КАК Ссылка,
	|	СпрНоменклатура.Код КАК Код,
	|	СпрНоменклатура.НомерПроизводителя КАК НомерПроизводителя,
	|	ПоступлениеЗапчастей.Номер КАК НомерПоступления,
	|	Контрагенты.Телефон КАК Телефон,
	|	Контрагенты.Город2 КАК Город
	|ИЗ
	|	Документ.ЗаявкаНаРасход.Товары КАК ЗаявкаНаРасходТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ЗаявкаНаРасходТовары.Номенклатура = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
	|		ПО ЗаявкаНаРасходТовары.Ссылка = ПоступлениеЗапчастей.ЗаявкаНаРасход
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ЗаявкаНаРасходТовары.Ссылка.Получатель = Контрагенты.Ссылка
	|ГДЕ
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьШапкаТЧ = Макет.ПолучитьОбласть("ОбластьШапкаТЧ");
	ОбластьТЧ = Макет.ПолучитьОбласть("ОбластьТЧ");
	ОбластьПодпись = Макет.ПолучитьОбласть("ОбластьПодпись");
	ТабДок.Очистить();
	
ВыборкаЗапрос.Следующий();
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьШапка, ВыборкаЗапрос.Уровень());
	
	ТабДок.Вывести(ОбластьШапкаТЧ);
	
	ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	
	Пока ВыборкаЗапрос.Следующий() Цикл
		ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьПодпись);
	
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	Возврат ТабДок;
	///-ГомзМА 05.04.2023 
	
КонецФункции

&НаКлиенте
Процедура ПечатьЗаявкаНаПоступление(Команда)
	
	///+ГомзМА 05.04.2023
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	//ПериодДляПечати = Элементы.ПериодДляПечати;
	ТабДок = ПечатьЗаявкаНаПоступлениеНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ЗаявкаНаПоступлениеЗапчастей");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ЗаявкаНаПоступлениеЗапчастей";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 05.04.2023
	
	//ПечатьЗаявкаНаПоступлениеНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	Элементы.СуммаДокумента.ТолькоПросмотр = Объект.Товары.Количество() <> 0;
	
	Элементы.Согласовал.ТолькоПросмотр = НЕ Форма.ЕстьПравоСогласования;
	Элементы.КомандаСогласовать.Видимость = НЕ Элементы.Согласовал.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСогласовать(Команда)
	
	Объект.Согласовал = ПользователиКлиентСервер.ТекущийПользователь();

КонецПроцедуры


&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ОбновитьСумму();
	ЗаполнитьСписокСогласовантов();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры
 // УправлениеФормой()


&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Товары.Отменено
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Товары");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Отменено", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДобавленныеКолонки()
	
	Оплачено = Ложь;

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СУММА(Расходы.Сумма) КАК Сумма
			|ИЗ
			|	Документ.Расходы КАК Расходы
			|ГДЕ
			|	Расходы.ЗаявкаНаРасход = &ЗаявкаНаРасход
			|	И Расходы.Проведен";
		
		Запрос.УстановитьПараметр("ЗаявкаНаРасход", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Оплачено = ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Сумма)
				И ВыборкаДетальныеЗаписи.Сумма >= Объект.СуммаДокумента; 
		КонецЕсли;
	
	КонецЕсли;
	
	СостояниеОплаты = ?(Оплачено, "Оплачено", "Не оплачено");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
			ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе	
		ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	КонецЕсли;
	
КонецПроцедуры
 // ОбработкаИзмененияСтроки()

&НаСервере
Процедура ЗаполнитьСписокСогласовантов()

	УстановитьПривилегированныйРежим(Истина);
	
	Элементы.Согласовал.СписокВыбора.Очистить();
	Элементы.Согласовал.СписокВыбора.Добавить(Справочники.Пользователи.ПустаяСсылка(), "Не согласовано");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.Ссылка,
		|	Пользователи.Представление
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	НЕ Пользователи.Недействителен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если Справочники.Пользователи.РазрешеноСогласование(Объект, ВыборкаДетальныеЗаписи.Ссылка) Тогда
			
			ФИО = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДетальныеЗаписи.Представление);
			Элементы.Согласовал.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ФИО);
			
		КонецЕсли;	
	КонецЦикла;
	
	ЕстьПравоСогласования = Элементы.Согласовал.СписокВыбора.НайтиПоЗначению(Пользователи.ТекущийПользователь()) <> Неопределено;
	
	// Проверка права у того, кто согласовал ранее
	Если ЗначениеЗаполнено(Объект.Согласовал) 
		И Элементы.Согласовал.СписокВыбора.НайтиПоЗначению(Объект.Согласовал) = Неопределено Тогда
		
		Объект.Согласовал = Неопределено;
		
	КонецЕсли;  
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСумму()
	
	Если Объект.Товары.Количество() <> 0 Тогда
		
		СтрокиАктивные = Объект.Товары.НайтиСтроки(Новый Структура("Отменено", Ложь));
		Сумма = 0;
		Для каждого СтрокаТаблицы Из СтрокиАктивные Цикл
			Сумма = Сумма + СтрокаТаблицы.Сумма;
		КонецЦикла;
		
		Объект.СуммаДокумента = Сумма;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПечатьЗаявкаНаРасходНаСервере()
	
	///+ГомзМА 21.04.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет  = Документы.ЗаявкаНаРасход.ПолучитьМакет("ЗаявкаНаРасход");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходТовары.Номенклатура КАК Номенклатура,
	|	ЗаявкаНаРасходТовары.Товар КАК Товар,
	|	ЗаявкаНаРасходТовары.Количество КАК Количество,
	|	ЗаявкаНаРасходТовары.Цена КАК Цена,
	|	ЗаявкаНаРасходТовары.Ссылка.Дата КАК Дата,
	|	ЗаявкаНаРасходТовары.Ссылка.Ответственный КАК Ответственный,
	|	ЗаявкаНаРасходТовары.Ссылка.Получатель КАК Получатель,
	|	ЗаявкаНаРасходТовары.Ссылка.ВидРасхода КАК ВидРасхода,
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка КАК Ссылка,
	|	СпрНоменклатура.Код КАК Код,
	|	СпрНоменклатура.НомерПроизводителя КАК НомерПроизводителя,
	|	ПоступлениеЗапчастей.Номер КАК НомерПоступления,
	|	Контрагенты.Телефон КАК Телефон,
	|	Контрагенты.Город2 КАК Город,
	|	ЗаявкаНаРасходТовары.НомерСтроки КАК НомерСтроки,
	|	ЗаявкаНаРасходТовары.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	ЗаявкаНаРасходТовары.Ссылка.Инициатор КАК Инициатор,
	|	ЗаявкаНаРасходТовары.Сумма КАК Сумма,
	|	ЗаявкаНаРасходТовары.Ссылка.Номер КАК Номер
	|ИЗ
	|	Документ.ЗаявкаНаРасход.Товары КАК ЗаявкаНаРасходТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ЗаявкаНаРасходТовары.Номенклатура = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
	|		ПО ЗаявкаНаРасходТовары.Ссылка = ПоступлениеЗапчастей.ЗаявкаНаРасход
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ЗаявкаНаРасходТовары.Ссылка.Получатель = Контрагенты.Ссылка
	|ГДЕ
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьШапка 	 = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьТЧ 		 = Макет.ПолучитьОбласть("ОбластьТЧ");
	ОбластьПодпись 	 = Макет.ПолучитьОбласть("ОбластьПодпись");
	ТабДок.Очистить();
	
	ВыборкаЗапрос.Следующий();
	
	ОбластьЗаголовок.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьЗаголовок, ВыборкаЗапрос.Уровень());
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьШапка, ВыборкаЗапрос.Уровень());
	
	ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	
	Пока ВыборкаЗапрос.Следующий() Цикл
		ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	КонецЦикла;
	
	ОбластьПодпись.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьПодпись);
	
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	Возврат ТабДок;
	///-ГомзМА 21.04.2023 
	
	
КонецФункции

&НаКлиенте
Процедура ПечатьЗаявкаНаРасход(Команда)
	
	///+ГомзМА 21.04.2023
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	//ПериодДляПечати = Элементы.ПериодДляПечати;
	ТабДок = ПечатьЗаявкаНаРасходНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ЗаявкаНаРасход");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров = 1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ЗаявкаНаРасход";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 21.04.2023
	
КонецПроцедуры

&НаСервере
Функция ПечатьЗаявкаНаРасходЗапчастейНаСервере()
	
	///+ГомзМА 24.04.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет  = Документы.ЗаявкаНаРасход.ПолучитьМакет("ЗаявкаНаРасходЗапчастей");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходТовары.Номенклатура КАК Номенклатура,
	|	ЗаявкаНаРасходТовары.Товар КАК Товар,
	|	ЗаявкаНаРасходТовары.Количество КАК Количество,
	|	ЗаявкаНаРасходТовары.Цена КАК Цена,
	|	ЗаявкаНаРасходТовары.Ссылка.Дата КАК Дата,
	|	ЗаявкаНаРасходТовары.Ссылка.Ответственный КАК Ответственный,
	|	ЗаявкаНаРасходТовары.Ссылка.Получатель КАК Получатель,
	|	ЗаявкаНаРасходТовары.Ссылка.ВидРасхода КАК ВидРасхода,
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка КАК Ссылка,
	|	СпрНоменклатура.Код КАК Код,
	|	СпрНоменклатура.НомерПроизводителя КАК НомерПроизводителя,
	|	ПоступлениеЗапчастей.Номер КАК НомерПоступления,
	|	Контрагенты.Телефон КАК Телефон,
	|	Контрагенты.Город2 КАК Город,
	|	ЗаявкаНаРасходТовары.НомерСтроки КАК НомерСтроки,
	|	ЗаявкаНаРасходТовары.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	ЗаявкаНаРасходТовары.Ссылка.Инициатор КАК Инициатор,
	|	ЗаявкаНаРасходТовары.Сумма КАК Сумма,
	|	ЗаявкаНаРасходТовары.Ссылка.Номер КАК Номер
	|ИЗ
	|	Документ.ЗаявкаНаРасход.Товары КАК ЗаявкаНаРасходТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ЗаявкаНаРасходТовары.Номенклатура = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
	|		ПО ЗаявкаНаРасходТовары.Ссылка = ПоступлениеЗапчастей.ЗаявкаНаРасход
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ЗаявкаНаРасходТовары.Ссылка.Получатель = Контрагенты.Ссылка
	|ГДЕ
	|	ЗаявкаНаРасходТовары.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьШапка 	 = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьТЧ 		 = Макет.ПолучитьОбласть("ОбластьТЧ");
	ОбластьПодпись 	 = Макет.ПолучитьОбласть("ОбластьПодпись");
	ТабДок.Очистить();
	
	ВыборкаЗапрос.Следующий();
	
	ОбластьЗаголовок.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьЗаголовок, ВыборкаЗапрос.Уровень());
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьШапка, ВыборкаЗапрос.Уровень());
	
	ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	
	Пока ВыборкаЗапрос.Следующий() Цикл
		ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
	КонецЦикла;
	
	ОбластьПодпись.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьПодпись);
	
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	Возврат ТабДок;
	///-ГомзМА 24.04.2023 
	
КонецФункции

&НаКлиенте
Процедура ПечатьЗаявкаНаРасходЗапчастей(Команда)
	
	///+ГомзМА 24.04.2023
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	//ПериодДляПечати = Элементы.ПериодДляПечати;
	ТабДок = ПечатьЗаявкаНаРасходЗапчастейНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ЗаявкаНаРасходЗапчастей");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров = 1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ЗаявкаНаРасходЗапчастей";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 24.04.2023
	
КонецПроцедуры


&НаСервере
Функция СоздатьДопТраты()

	///+ГомзМА 25.09.2023
	Если Объект.Ссылка = Документы.ЗаявкаНаРасход.ПустаяСсылка() Тогда
		Если Объект.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000043") ИЛИ
			Объект.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000044") ИЛИ
			Объект.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000039") Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	УстановитьЗП.ВидРасхода КАК ВидРасхода,
			|	УстановитьЗП.Зарплата КАК Зарплата,
			|	УстановитьЗП.Учредитель КАК Учредитель
			|ИЗ
			|	РегистрСведений.УстановитьЗП КАК УстановитьЗП
			|ГДЕ
			|	УстановитьЗП.ВидРасхода = &ВидРасхода";
			
			Запрос.УстановитьПараметр("ВидРасхода", Объект.ВидРасхода);
			
			РезультатЗапроса = Запрос.Выполнить().Выбрать();
			
			РезультатЗапроса.Следующий();
			
			СуммаЗаОтчетныйПериод = ПолучитьСуммуЗаОтчетныйПериод();
			
			Если СуммаЗаОтчетныйПериод + Объект.СуммаДокумента > РезультатЗапроса.Зарплата Тогда
				ДопТраты = СуммаЗаОтчетныйПериод + Объект.СуммаДокумента - РезультатЗапроса.Зарплата;
				
				НовыйДокумент = Документы.ЛичныйВывод.СоздатьДокумент();
				НовыйДокумент.Дата 		 = ТекущаяДатаСеанса();
				НовыйДокумент.Учредитель = РезультатЗапроса.Учредитель;
				НовыйДокумент.Откуда 	 = Объект.Счет;
				НовыйДокумент.Сумма 	 = ДопТраты;
				НовыйДокумент.Записать();
				
				Объект.СуммаДокумента = Объект.СуммаДокумента - ДопТраты;
				Если Объект.СуммаДокумента = 0 Тогда
					Сообщить("Зарплата за отчетный месяц уже выдана! Дополнительные траты созданы.");
				КонецЕсли;
				
				Возврат НовыйДокумент.Ссылка;
				
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	///-ГомзМА 25.09.2023

КонецФункции



&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()

	///+ГомзМА 26.09.2023
	Если Объект.ВидРасхода.ВидОперацииСписаниеДенежныхСредств = Перечисления.ВидыОперацийСписаниеДенежныхСредств.Зарплата Тогда
		Элементы.Месяц.Видимость = Истина;
	Иначе
		Элементы.Месяц.Видимость = Ложь;
	КонецЕсли;
	///-ГомзМА 26.09.2023
	
	///+ГомзМА 21.12.2023
	Если Объект.ВидРасхода = Справочники.ВидыРасходов.КредитПлатеж Тогда
		Элементы.Кредит.Видимость = Истина;
		Элементы.НаименованиеКредита.Видимость = Истина;
	Иначе
		Элементы.Кредит.Видимость = Ложь;
		Элементы.НаименованиеКредита.Видимость = Ложь;
	КонецЕсли;
	///-ГомзМА 21.12.2023
	
	КонецПроцедуры


&НаСервере
Функция ПолучитьСуммуЗаОтчетныйПериод()

	///+ГомзМА 26.09.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ЕСТЬNULL(ЗаявкаНаРасход.СуммаДокумента, 0)) КАК Сумма
		|ПОМЕСТИТЬ ВТ_Сумма
		|ИЗ
		|	Документ.ЗаявкаНаРасход КАК ЗаявкаНаРасход
		|ГДЕ
		|	ЗаявкаНаРасход.ВидРасхода = &ВидРасхода
		|	И ЗаявкаНаРасход.Месяц = &Месяц
		|	И ГОД(ЗаявкаНаРасход.Дата) = &Год
		|	И ЗаявкаНаРасход.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_Сумма.Сумма, 0) КАК Сумма
		|ИЗ
		|	ВТ_Сумма КАК ВТ_Сумма";
	
	Запрос.УстановитьПараметр("ВидРасхода", 	Объект.ВидРасхода);
	Запрос.УстановитьПараметр("Месяц", 			Объект.Месяц);
	Запрос.УстановитьПараметр("Год", 			Год(Объект.Дата));
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	РезультатЗапроса.Следующий();

	Возврат РезультатЗапроса.Сумма;
	///-ГомзМА 26.09.2023

КонецФункции // ПолучитьСуммуЗаОтчетныйПериод()

&НаСервере
Процедура СчетПриИзмененииНаСервере()

	  Если Не Объект.Организация = Объект.Счет Тогда 
		
		Объект.Организация = Неопределено;
		Объект.Организация = Объект.Счет.Владелец
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	СчетПриИзмененииНаСервере();
КонецПроцедуры













#КонецОбласти