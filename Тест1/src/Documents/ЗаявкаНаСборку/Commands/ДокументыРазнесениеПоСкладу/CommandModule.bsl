
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура();
	ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаявокНаСборку.РазнесениеПоСкладу"); 
	ПараметрыФормы.Вставить("Отбор", Новый Структура("ВидОперации", ВидОперации));
	ПараметрыФормы.Вставить("Заголовок", "Разнесения по складу");
	ОткрытьФорму("Документ.ЗаявкаНаСборку.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ВидОперации, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры