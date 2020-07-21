/* Each row is a node in the object */

select '0' [Lvl], 'public' [SecType], '' [Node],/* TODO might want to do this if I want to make a big hash table with this*/
[Hash].[Value] [Key], [Value].[Value] [Value], [Value].[Value] [InnerText]
from LinkInfo Link
/* HASH : Name of the Key */
join PersonalInfo Hash on Link.[Hash] = [Hash].GUID
/* VALUE : Is the key's value */
join PersonalInfo Value on Link.PersonalInfoID = [Value].ID
where Link.Link = @Link