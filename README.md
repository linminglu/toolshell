1 frameworkbuildfor x86 i386  arm 
编译framework 用到的shell 使得该库可以支持多个平台，模拟器和真机
2 在html 上按键加入音效的方法：
借用别人的appid来做测试：
05DBC69E5594C137B9E22680F92F8E5E0A077706
3AFAC12D1A7C674242EE37C45BD5E3293DDF4A74

this.playAudio =function (szWords){
    if (szWords == "")
                 return;
    var audio = new Audio("http://api.microsofttranslator.com/V2/http.svc/Speak?oncomplete=Speech.onSpeechComplete&appId=3AFAC12D1A7C674242EE37C45BD5E3293DDF4A74&language=zh-chs&text=" + szWords)
    audio.play();       
}   



3 更新appicon 制作工具。 后续再添加安卓的appicon的制作。   
运行测试python appiconmake.py [imagename] [outputfile]