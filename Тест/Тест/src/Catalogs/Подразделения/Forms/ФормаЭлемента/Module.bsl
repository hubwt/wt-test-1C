
&НаКлиенте
Процедура СписокОбязанностейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия    = Элементы.СписокОбязанностей.ТекущиеДанные[СтрЗаменить(Поле.Имя,Элемент.имя,"")];
	ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
	Если ТипЗнч(СсылкаДляОткрытия)=тип("СправочникСсылка.Обязанности") Тогда
		ИмяФормыДокумента="Справочник.обязанности.Форма.Формаэлемента";
		//ИначеЕсли ТипЗнч(СсылкаДляОткрытия)=тип("ДокументСсылка.КадровыйПриказ") Тогда
		//ИмяФормыДокумента="Документ.КадровыйПриказ.Форма.ФормаДокумента";
		//Возврат;
	КонецЕсли;
	
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеФормой(ЭтаФорма);
	ОбновитьСписки();
	ОбновитьКоличествоОбязанностей();
КонецПроцедуры

Процедура ОбновитьСписки()
	СписокДолжостей.Параметры.УстановитьЗначениеПараметра("Родитель", Объект.Ссылка);
	СписокОбязанностей.Параметры.УстановитьЗначениеПараметра("Отдел", Объект.Ссылка);
	СписокКадровыеПриказы.Параметры.УстановитьЗначениеПараметра("Отдел", Объект.Ссылка);
	СписокСотрудников.Параметры.УстановитьЗначениеПараметра("Родитель", Объект.Ссылка);
КонецПроцедуры
&НаСервере
Процедура ОбновитьКоличествоОбязанностей()
Для каждого стр из объект.Должности Цикл
Запрос = новый Запрос();
Запрос.Текст = "ВЫБРАТЬ
|	КОЛИЧЕСТВО(ОбязанностиСписокДолжностей.Ссылка) КАК Ссылка,
|	ПодразделенияДолжности.Должность
|ИЗ
|	Справочник.Подразделения.Должности КАК ПодразделенияДолжности
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Обязанности.СписокДолжностей КАК ОбязанностиСписокДолжностей
|		ПО ПодразделенияДолжности.Должность = ОбязанностиСписокДолжностей.Должность
|ГДЕ
|	ПодразделенияДолжности.Должность = &Должность
|СГРУППИРОВАТЬ ПО
|	ПодразделенияДолжности.Должность";
запрос.УстановитьПараметр("Должность",стр.Должность );
//@skip-check query-in-loop
 Выборка = Запрос.Выполнить().Выбрать();
 Выборка.следующий();
 Стр.КоличествоОбязанностей = ВЫборка.Ссылка
КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьДолжности(Команда)
	Если ТумблерДолжностей Тогда
		Элементы.ПоказатьСкрытьДолжности.Заголовок = "Показать должности и сотрудников всех подотделов";
		Элементы.СписокДолжостей.Видимость = Ложь;
		Элементы.Должности1.Видимость = Истина;
		Элементы.Участники.Видимость = Истина;
		Элементы.СписокСотрудников.Видимость = Ложь;
		ТумблерДолжностей = Ложь;
	Иначе
		Элементы.ПоказатьСкрытьДолжности.Заголовок = "Показать должности и сотрудников этого отдела";
		Элементы.СписокДолжостей.Видимость = Истина;
		Элементы.Должности1.Видимость = Ложь;
		Элементы.Участники.Видимость = Ложь;
		Элементы.СписокСотрудников.Видимость = Истина;
		ТумблерДолжностей = Истина;
	КонецЕсли;	
ОбновитьСписки();
КонецПроцедуры


&НаКлиенте
Процедура ОБновитьОбязанности(Команда)
	ОбновитьКоличествоОбязанностей();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭтоЦФОПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



&НаКлиенте
Процедура УчастникиСотрудникОткрытие(Элемент, СтандартнаяОбработка)
	//УчастникиСотрудникОткрытиеНаСервере();
	ТекДанные = Элементы.Участники.ТекущиеДанные;
	СтандартнаяОбработка = Ложь;
	СсылкаДляОткрытия=УчастникиСотрудникОткрытиеНаСервере(ТекДанные.сотрудник);
	ПараметрыФормы = Новый Структура("Ключ", СсылкаДляОткрытия);
	//Если ТипЗнч(СсылкаДляОткрытия)=тип("справочникСсылка.Обязанности") Тогда
		ИмяФормыДокумента="справочник.сотрудники.Форма.ФормаЭлемента";
	//Иначе
	//	Возврат;
	//КонецЕсли;
	ФормаДокумента = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	ФормаДокумента.Открыть();
КонецПроцедуры

&НаСервере
Функция УчастникиСотрудникОткрытиеНаСервере(Юзер)
	Возврат Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",Юзер);
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	//Элементы.Город.Видимость = Объект.ЭтоЦФО;
	
КонецПроцедуры



#КонецОбласти

