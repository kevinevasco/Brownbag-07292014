public class xTestEbm_MultipleContacts
{

 public String noOfDays { get; set; }
 public List<AccountWrapper> wrappers {get; set;}
 public static Integer toDelIdent {get; set;}
 public static Integer addCount {get; set;}
 private Integer nextIdent=1;
  
 public xTestEbm_MultipleContacts(){
  wrappers=new List<AccountWrapper>();
  for (Integer idx=0; idx<0; idx++)
  {
   wrappers.add(new AccountWrapper(nextIdent++));
  }
 }
  
 public void delWrapper(){
  Integer toDelPos=-1;
  for (Integer idx=0; idx<wrappers.size(); idx++)
  {
   if (wrappers[idx].ident==toDelIdent)
   {
    toDelPos=idx;
   }
  }
   
  if (-1!=toDelPos)
  {
   wrappers.remove(toDelPos);
  }
 }
  
 public void addRows(){

 addCount = Integer.valueOf(noOfDays);
  System.Debug('addCount ::: '+addCount);
  for (Integer idx=1; idx<=addCount; idx++)
  {
   wrappers.add(new AccountWrapper(nextIdent++));
  }
 }
  
 public PageReference save(){
  List<Contact> accs=new List<Contact>();
  for (AccountWrapper wrap : wrappers)
  {
   accs.add(wrap.acc);
  }
   
  insert accs;
   
  return new PageReference('/' + Schema.getGlobalDescribe().get('Contact').getDescribe().getKeyPrefix() + '/o');
 }
  
 public class AccountWrapper{
  public Contact acc {get; private set;}
  public Integer ident {get; private set;}
   
  public AccountWrapper(Integer inIdent)
  {
   ident=inIdent;
   acc=new Contact();
  }
 }
}