#Область ПрограммныйИнтерфейс
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
Функция ДатаНачалаУчетаОплатПоСделкам() Экспорт

	
	Возврат '20180301';

КонецФункции // ДатаНачалаУчетаОплатПоСделкам()


// Выполняет движения регистра накопления дт_НачислениеЗарплатыУУ
//
Процедура ОтразитьНачислениеЗарплаты(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаНачислениеЗарплаты;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.дт_НачислениеЗарплатыУУ;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры

// Выполняет движения регистра накопления дт_НачислениеЗарплатыБУ
//
Процедура ОтразитьНачислениеЗарплатыБУ(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаНачислениеЗарплатыБУ;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.дт_НачислениеЗарплатыБУ;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры


// Выполняет движения регистра накопления ОтработанноеВремя
//
Процедура ОтразитьОтработанноеВремя(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаОтработанноеВремя;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.ОтработанноеВремя;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры



// Выполняет движения регистра накопления ДолжностиСотрудников
//
Процедура ОтразитьДолжностиСотрудников(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаДолжностиСотрудников;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.ДолжностиСотрудников;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры


// Выполняет движения регистра накопления дт_НачисленияФиксированныеПлан
//
Процедура ОтразитьНадбавкиПлан(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаНадбавки;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.дт_НачисленияФиксированныеПлан;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры

Функция ПолучитьВремяПоТабелю(Сотрудник, НачалоПериода, КонецПериода, ТипДня = Неопределено, Способ = Неопределено) Экспорт

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтработанноеВремяОбороты.Период КАК Период,
		|	ОтработанноеВремяОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.ОтработанноеВремя.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			День,
		|			Сотрудник = &Сотрудник
		|				И ТипДня = &ТипДня) КАК ОтработанноеВремяОбороты";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("ТипДня", ?(ТипДня = Неопределено, Перечисления.ТипыДнейТабеля.РабочийДень, ТипДня));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Результат = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Способ = Перечисления.СпособыНачисленияОклада.ПоЧасам Тогда
			Результат = Результат + ВыборкаДетальныеЗаписи.Количество;
		Иначе
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	

КонецФункции // ПолучитьОтработанноеВремя()

Функция ПолучитьРабочееВремяПоКалендарю(Календарь, НачалоПериода, КонецПериода, Способ) Экспорт
	
	Результат = 0;
	РабочиеДни = ГрафикиРаботы.РасписанияРаботыНаПериод(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Календарь),
		НачалоПериода,
		КонецПериода
	);
	
	ПредДень = Неопределено;
		
	Для каждого РабочийДень Из РабочиеДни Цикл
	
		Результат = Результат + 
			?(Способ = Перечисления.СпособыНачисленияОклада.ПоДням,
				?(РабочийДень.ДатаГрафика = ПредДень, 0, 1),
				?(ЗначениеЗаполнено(РабочийДень.ВремяНачала), (РабочийДень.ВремяОкончания - РабочийДень.ВремяНачала) / 3600, 8)  // в часах 
			);
		ПредДень = РабочийДень.ДатаГрафика;
		
	КонецЦикла;
		
	Возврат Результат;	
			
КонецФункции
		
Функция ПолучитьКадровыеДанные(Сотрудник, Дата = Неопределено, Организация = Неопределено, Подразделение = Неопределено, ПолучитьВсеДанные = Ложь) Экспорт
	
	
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.Организация,
	|	ДолжностиСотрудниковСрезПоследних.Подразделение,
	|	ДолжностиСотрудниковСрезПоследних.Должность,
	|	ДолжностиСотрудниковСрезПоследних.Период,
	|	ДолжностиСотрудниковСрезПоследних.ДатаОформления,
	|	ДолжностиСотрудниковСрезПоследних.ОкладБУ,
	|	ДолжностиСотрудниковСрезПоследних.Оклад
	|ПОМЕСТИТЬ втИстория
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(&Дата, &Отбор) КАК ДолжностиСотрудниковСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втИстория.Организация,
	|	МАКСИМУМ(втИстория.Период) КАК Период
	|ПОМЕСТИТЬ втДатыСреза
	|ИЗ
	|	втИстория КАК втИстория
	|СГРУППИРОВАТЬ ПО
	|	втИстория.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втИстория.Организация,
	|	втИстория.Подразделение,
	|	втИстория.Должность,
	|	втИстория.ДатаОформления,
	|	втИстория.Период КАК ДатаПриема,
	|	втИстория.ОкладБУ,
	|	втИстория.Оклад
	|ИЗ
	|	втИстория КАК втИстория
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДатыСреза КАК втДатыСреза
	|		ПО втИстория.Организация = втДатыСреза.Организация
	|		И втИстория.Период = втДатыСреза.Период
	|		И НЕ втИстория.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|		И НЕ втИстория.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиПредприятия.ПустаяСсылка)
	|УПОРЯДОЧИТЬ ПО
	|	втИстория.Период УБЫВ";

	Отбор = "Сотрудник = &Сотрудник";
	Если Организация <> Неопределено Тогда
		
		Отбор = Отбор + " И Организация = &Организация";
		Запрос.УстановитьПараметр("Организация", Организация);
		
	КонецЕсли;
	
	Если Подразделение <> Неопределено Тогда
		
		Отбор = Отбор + " И Подразделение = &Подразделение";
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Отбор", Отбор);
	
	Запрос.УстановитьПараметр("Дата", ?(Дата = Неопределено, ТекущаяДата(), Дата));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);

	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результаты = РезультатЗапроса.Выгрузить();
	
	Если ПолучитьВсеДанные Тогда
		Результат = ОбщегоНазначения.ТаблицаЗначенийВМассив(Результаты);
		
		
	ИначеЕсли Организация = Неопределено И Подразделение = Неопределено Тогда
		Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Результаты[0]);
		
	Иначе
		Результат = ОбщегоНазначения.ТаблицаЗначенийВМассив(Результаты);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

Функция ПолучитьГоловноеПодразделение(Подразделение) Экспорт
	
	Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "Родитель");
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		Возврат ПолучитьГоловноеПодразделение(Родитель);
	КонецЕсли;
		
	Возврат Подразделение;
	
КонецФункции

Функция ПолучитьСтавкуСотрудника(Сотрудник, Дата) Экспорт

	ПараметрыДолжности = ПолучитьПараметрыДолжности(Сотрудник, Дата);
	
	Если ПараметрыДолжности = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ПараметрыДолжности.Ставка;
	
	Возврат Результат;
	
КонецФункции	

Функция ПолучитьПараметрыДолжности(Сотрудник, Дата, КадровыеДанные = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	Если КадровыеДанные = Неопределено Тогда
		КадровыеДанные = ПолучитьКадровыеДанные(Сотрудник, Дата);
	КонецЕсли;	
	
	Если КадровыеДанные = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
		
	Должность = КадровыеДанные.Должность;	
	
	Если Не ЗначениеЗаполнено(Должность) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Должность, "СпособНачисленияОклада,СпособНачисленияПремии"
		+ ",СпособНачисленияСдельнойОплаты,Календарь,ПрофильПоказателей,ВычитатьНеявкиИзСдельнойОплаты"
	);
	
	Срез = РегистрыСведений.ПараметрыДолжностей.СрезПоследних(Дата, Новый Структура("Должность", Должность));
	
	Если Срез.Количество() <> 0 Тогда
		
		// Оклад сотрудника приоритетнее оклада по должности
		ПараметрыДолжности = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Срез[0]);
		
		Если КадровыеДанные.Оклад <> 0 Тогда
			ПараметрыДолжности.Оклад = КадровыеДанные.Оклад; 	
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, 
			ПараметрыДолжности,
			Истина
		);
	Иначе	
		
		Результат.Вставить("Оклад", КадровыеДанные.Оклад);
		Результат.Вставить("Ставка", 0);
		Результат.Вставить("Процент", 0);
		Результат.Вставить("ВидАналитики", Неопределено);
		
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции	
		
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти