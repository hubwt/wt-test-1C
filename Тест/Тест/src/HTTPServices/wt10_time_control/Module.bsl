
#Область ОбработчикиСобытий

Функция ПолучитьСписокВсехРуководителейgetallbosseslist(Запрос)
	
	///+ТатарМА 08.11.2024
	ЗапросРуководителей = Новый Запрос;
	ЗапросРуководителей.Текст = "ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	ДолжностиСотрудниковСрезПоследних.Организация КАК Организация,
	|	ДолжностиСотрудниковСрезПоследних.Подразделение КАК Подразделение,
	|	ДолжностиСотрудниковСрезПоследних.Должность КАК Должность,
	|	ДолжностиСотрудниковСрезПоследних.ТипДоговора КАК ТипДоговора,
	|	ДолжностиСотрудниковСрезПоследних.Период КАК Период
	|ПОМЕСТИТЬ втДолжности
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|ГДЕ
	|	НЕ ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь.Недействителен
	|	И НЕ ДолжностиСотрудниковСрезПоследних.Сотрудник.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	Организация,
	|	Подразделение,
	|	Должность,
	|	ТипДоговора,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДолжности.Сотрудник КАК Сотрудник,
	|	МАКСИМУМ(втДолжности.Период) КАК Период
	|ПОМЕСТИТЬ втДолжностиПериоды
	|ИЗ
	|	втДолжности КАК втДолжности
	|СГРУППИРОВАТЬ ПО
	|	втДолжности.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДолжности.Сотрудник КАК Сотрудник,
	|	МИНИМУМ(втДолжности.Организация) КАК Организация,
	|	МИНИМУМ(втДолжности.Подразделение) КАК Подразделение,
	|	МИНИМУМ(втДолжности.Должность) КАК Должность,
	|	МИНИМУМ(втДолжности.ТипДоговора) КАК ТипДоговора,
	|	МИНИМУМ(втДолжности.Подразделение.Код) КАК ПодразделениеКод,
	|	МИНИМУМ(втДолжности.Должность.Код) КАК ДолжностьКод
	|ПОМЕСТИТЬ втДолжностиСотрудников
	|ИЗ
	|	втДолжности КАК втДолжности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДолжностиПериоды КАК втДолжностиПериоды
	|		ПО втДолжности.Сотрудник = втДолжностиПериоды.Сотрудник
	|		И (втДолжностиПериоды.Период = втДолжности.Период)
	|СГРУППИРОВАТЬ ПО
	|	втДолжности.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
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
	|СГРУППИРОВАТЬ ПО
	|	КадровыйПриказ.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
	|	СотрудникиКонтактнаяИнформация.Представление КАК Представление,
	|	СотрудникиКонтактнаяИнформация.Представление КАК ТелефонЛичный
	|ПОМЕСТИТЬ ТелефоныЛичные
	|ИЗ
	|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
	|ГДЕ
	|	СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаЛичный)
	|	И НЕ СотрудникиКонтактнаяИнформация.Ссылка.Пользователь.Недействителен
	|	И НЕ СотрудникиКонтактнаяИнформация.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
	|	СотрудникиКонтактнаяИнформация.Представление КАК Представление,
	|	СотрудникиКонтактнаяИнформация.Представление КАК ТелефонСлужебный
	|ПОМЕСТИТЬ ТелефоныСлужебные
	|ИЗ
	|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
	|ГДЕ
	|	СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаСлужебный)
	|	И НЕ СотрудникиКонтактнаяИнформация.Ссылка.Пользователь.Недействителен
	|	И НЕ СотрудникиКонтактнаяИнформация.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТелефоныЛичные.ТелефонЛичный КАК ТелефонЛичный,
	|	ТелефоныСлужебные.ТелефонСлужебный КАК ТелефонСлужебный,
	|	Сотрудники.Наименование КАК Наименование,
	|	Сотрудники.Код КАК Код,
	|	втДолжностиСотрудников.Организация КАК Организация,
	|	втДолжностиСотрудников.ПодразделениеКод КАК ПодразделениеКод,
	|	втДолжностиСотрудников.Подразделение КАК Подразделение,
	|	втДолжностиСотрудников.ДолжностьКод КАК ДолжностьКод,
	|	втДолжностиСотрудников.Должность КАК Должность,
	|	Сотрудники.ДатаРождения КАК ДатаРождения,
	|	ЕСТЬNULL(втДолжностиСотрудников.Должность,
	|		ЗНАЧЕНИЕ(Справочник.ДолжностиПредприятия.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.ДолжностиПредприятия.ПустаяСсылка) КАК
	|		Действующий,
	|	Сотрудники.Руководитель КАК Руководитель,
	|	Сотрудники.МестоРаботы КАК МестоРаботы,
	|	Сотрудники.ПарольДляУК КАК ПарольДляУК,
	|	Сотрудники.РолиWT10.(
	|		НомерСтроки КАК НомерСтроки,
	|		Роль КАК Роль) КАК РолиWT10,
	|	Сотрудники.Тележка КАК Тележка,
	|	Сотрудники.Тележка.Код КАК ТележкаКод,
	|	ПодразделенияУчастники.Ссылка.Код КАК КодПодразделения,
	|	Сотрудники.ПарольДляУК КАК ПарольДляУК1
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДолжностиНовые КАК ВТ_ДолжностиНовые
	|		ПО (ВТ_ДолжностиНовые.Сотрудник = Сотрудники.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДолжностиСотрудников КАК втДолжностиСотрудников
	|		ПО (втДолжностиСотрудников.Сотрудник = Сотрудники.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТелефоныЛичные КАК ТелефоныЛичные
	|		ПО (ТелефоныЛичные.Ссылка = Сотрудники.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТелефоныСлужебные КАК ТелефоныСлужебные
	|		ПО (ТелефоныСлужебные.Ссылка = Сотрудники.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Подразделения.Участники КАК ПодразделенияУчастники
	|		ПО (ПодразделенияУчастники.Сотрудник = Сотрудники.Пользователь)
	|ГДЕ
	|	НЕ Сотрудники.Пользователь.Недействителен
	|	И НЕ Сотрудники.ПометкаУдаления
	|	И Сотрудники.РолиWT10.Роль.Код = ""000000007""";
	ВыборкаРуководителей = ЗапросРуководителей.Выполнить().Выбрать();

	МассивРуководителей = Новый массив;

	Пока ВыборкаРуководителей.Следующий() Цикл
		СтруктураРуководителей = Новый Структура;

		СтруктураРуководителей.Вставить("name", Строка(ВыборкаРуководителей.Наименование));
		СтруктураРуководителей.Вставить("code", Строка(ВыборкаРуководителей.Код));

		МассивРуководителей.Добавить(СтруктураРуководителей);
	КонецЦикла;
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("data", МассивРуководителей);

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, МассивРуководителей);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
	///-ТатарМА 08.11.2024
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
