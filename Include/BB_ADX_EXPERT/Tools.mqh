//+----------------------------------------------------------------------+
//|      Collection de fonctions pour les traitements                    | 
//+----------------------------------------------------------------------+

//+-------------------------------------------------------------------+
//| ErrorToString                                                     |
//+-------------------------------------------------------------------+
string ErrorToString(const int error)
{
   switch(error)
   {
      case ERR_NOTIFICATION_SEND_FAILED         : return("ERR_NOTIFICATION_SEND_FAILED");
      case ERR_NOTIFICATION_TOO_FREQUENT        : return("ERR_NOTIFICATION_TOO_FREQUENT");
      case ERR_NOTIFICATION_WRONG_PARAMETER     : return("ERR_NOTIFICATION_WRONG_PARAMETER");
      case ERR_NOTIFICATION_WRONG_SETTINGS      : return("ERR_NOTIFICATION_WRONG_SETTINGS");
      default                                   : return("Erreur non référencée :( !!!");
   }
}

//+--------------------------------------------------------------------+
//| CleanString                                                        |
//+--------------------------------------------------------------------+
void CleanString(string& i_string)
{
   StringTrimRight (i_string);
   StringTrimLeft  (i_string);
}

//+--------------------------------------------------------------------+
//| FolderNameControl                                                  |
//+--------------------------------------------------------------------+
bool FolderNameControl(const string i_folder, const bool i_backslashVerif = false)
{
   string   l_folder;
   ushort   l_charactere;
   int      l_loop;

   l_folder = i_folder;
   CleanString(l_folder);

   if (l_folder == "") return(false);

   for (l_loop = 0; l_loop < StringLen(l_folder); l_loop++)
   {
      l_charactere = StringGetCharacter(l_folder, l_loop);
      if (l_charactere < ' ') return(false);
      if (l_charactere ==  '/' ) return(false);
      if (l_charactere ==  ':' ) return(false);
      if (l_charactere ==  '*' ) return(false);
      if (l_charactere ==  '?' ) return(false);
      if (l_charactere ==  '<' ) return(false);
      if (l_charactere ==  '>' ) return(false);
      if (l_charactere ==  '|' ) return(false);
      if (l_charactere == '"' ) return(false);
   }
   
   if (i_backslashVerif)
   {
      if (StringSubstr(l_folder, StringLen(l_folder) - 1 , 1) != "\\") return(false);
   }
   
   return(true);   
}

//+--------------------------------------------------------------------+
//| FileNameControl                                                    |
//+--------------------------------------------------------------------+
bool FileNameControl(const string i_folder)
{
   return(FolderNameControl(i_folder));
}

//+--------------------------------------------------------------------+
//| SoundNameControl                                                   |
//+--------------------------------------------------------------------+
void SoundNameControl(string& i_sound, const string i_function = "")
{
   if (MQLInfoInteger(MQL_TESTER))
   {
      return;
   }
   if (PlaySound(i_sound) == false)
   {
      i_sound = "alert2.wav";
      if (PlaySound(i_sound) == false)
      {
         i_sound = "";
      }
   }
   PlaySound(NULL);
}

//+--------------------------------------------------------------------+
//| BoolToString                                                       |
//+--------------------------------------------------------------------+
string BoolToString(bool value)
{
   return(value ? "Vrai" : "Faux");
}

//+--------------------------------------------------------------------+
//| ImpactToString                                                     |
//+--------------------------------------------------------------------+
string ImpactToString(ENUM_IMPACT_LEVEL value)
{
   switch (value)
   {
      case eI_Nothing : return("Aucun");
      case eI_Minor   : return("Mineur");
      case eI_Medium  : return("Moyen");
      case eI_Major   : return("Majeur");
      default         : return("???");
   }
}

//+--------------------------------------------------------------------+
//| TrendToString                                                      |
//+--------------------------------------------------------------------+
string TrendToString(ENUM_TREND trend)
{
   switch(trend)
   {
      case eT_Bull : return("Bull");
      case eT_Bear : return("Bear");
      default      : return("???");
   }
}

//+--------------------------------------------------------------------+
//| PeriodToString                                                     |
//+--------------------------------------------------------------------+
string PeriodToString(const ENUM_TIMEFRAMES TF)
{
   ENUM_TIMEFRAMES l_TF = (TF == PERIOD_CURRENT) ? ENUM_TIMEFRAMES(Period()) : TF;

   switch (l_TF)
   {
      case PERIOD_M1  : return("M1");
      case PERIOD_M5  : return("M5");
      case PERIOD_M15 : return("M15");
      case PERIOD_M30 : return("M30");
      case PERIOD_H1  : return("H1");
      case PERIOD_H4  : return("H4");
      case PERIOD_D1  : return("D1");
      default         : return("???");
   }
}
