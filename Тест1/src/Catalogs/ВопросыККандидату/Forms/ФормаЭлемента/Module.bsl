
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.Кандидат_вакансия) Тогда
		НоваяСтрока = объект.Вакансии.Добавить();
		НоваяСтрока.вакансия = Параметры.Кандидат_вакансия;
	КонецЕсли;
	
КонецПроцедуры
