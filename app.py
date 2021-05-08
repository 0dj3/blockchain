from web3 import Web3
from flask import Flask, render_template, request, jsonify
import json

#####
### Ссылки и ключи
#####
infura_url = 'https://ropsten.infura.io/v3/7c0e56536deb4a489f60537ee8cbf06f'
address = 'manna address'
contract_address = '0x24b02b3FAb26d2283Bd1D2D3a31f304508066fb9'
private_key = 'manna klu4'

#####
### Магия
#####
app = Flask(__name__)

w3 = Web3(Web3.HTTPProvider(infura_url))
w3.eth.defaultAccount = address
with open('rosreestr.abi') as f:
    abi = json.load(f)
contract = w3.eth.contract(address=contract_address, abi=abi)
nonce = w3.eth.getTransactionCount(address)

#####
### Мб наада буолуо
#####

##Get Balance
#balance = w3.eth.getBalance(address)
#print(w3.fromWei(balance, 'ether'))

##Get Owner
#print(contract.functions.GetOwner().call())

#####
### Переходы между страницами
#####
@app.route('/')
def index():
    return render_template("index.html")

@app.route('/addEmployee')
def addEmp():
    return render_template("addemployee.html")


@app.route('/getEmployee')
def getEmp():
    return render_template("getemployee.html")


@app.route('/addRequest')
def addReq():
    return render_template("addrequest.html")

@app.route('/processRequest')
def proReq():
    return render_template("processrequest.html")


#####
### Запросы
#####

@app.route('/addEmployee', methods=['POST'])
def addEmployee():
    employeeAdrs = request.form.get("em0x24b02b3FAb26d2283Bd1D2D3a31f304508066fb9ployeeAdrs")
    fio = request.form.get("fio")
    eployeePos = request.form.get("eployeePos")
    phoneNum = request.form.get("phoneNum")
    empl_tr = contract.functions.AddEmployee(employeeAdrs, fio , eployeePos, str(phoneNum)).buildTransaction({
        'gas': 3000000,
        'gasPrice': w3.toWei('100', 'gwei'),
        'from': address,
        'nonce': nonce,
    })
    signed_tr = w3.eth.account.signTransaction(empl_tr, private_key=private_key)
    w3.eth.sendRawTransaction(signed_tr.rawTransaction)
    return render_template("addemployee.html")

@app.route('/getEmployee', methods=['POST'])
def getEmployee():
    employeeAdrs = request.form.get("employeeAdrs")
    res = (contract.functions.GetEmployee(employeeAdrs).call())
    return render_template("getemployee.html")+'<p> ФИО: '+str(res[0])+'</p>'+'<p> Должность: '+str(res[1])+'</p>'+'<p> Номер телефона: '+str(res[2])+'</p>'

@app.route('/addRequest', methods=['POST'])
def addRequest():
    rType = request.form.get("rType")
    homeAddress = request.form.get("homeAddress")
    area = request.form.get("area")
    cost = request.form.get("cost")
    newOwner = request.form.get("newOwner")
    req_tr = contract.functions.AddRequest(int(rType), homeAddress, int(area), int(cost), newOwner).buildTransaction({
        'gas': 3000000,
        'gasPrice': w3.toWei('100', 'gwei'),
        'from': address,
        'nonce': nonce,
        'value':w3.toWei('100','gwei')
    })
    signed_tr = w3.eth.account.signTransaction(req_tr, private_key=private_key)
    w3.eth.sendRawTransaction(signed_tr.rawTransaction) 
    return render_template("addrequest.html")

@app.route('/processrequest', methods=['POST'])
def processRequest():
    reqId = request.form.get("reqId")
    req_tr = contract.functions.ProcessRequest(int(reqId)).buildTransaction({
        'gas': 3000000,
        'gasPrice': w3.toWei('100', 'gwei'),
        'from': address,
        'nonce': nonce,
    })
    signed_tr = w3.eth.account.signTransaction(req_tr, private_key=private_key)
    w3.eth.sendRawTransaction(signed_tr.rawTransaction) 
    return render_template("processrequest.html")


@app.route('/getRequest')
def getRequest():
    res = (contract.functions.GetRequest().call())
    win = "<table>"
    for column in res:
        win += "<tr>"
        for row in range(len(column)):
            win += "<td>"+str(column[row])+"</td> "
        win += "</tr>"
    win += "</table>"
    return win

@app.route('/getHome')
def getHome():
    res = (contract.functions.GetListHome().call())
    win = "<table>"
    for column in res:
        win += "<tr>"
        for row in range(len(column)):
            win += "<td>"+str(column[row])+"</td> "
        win += "</tr>"
    win += "</table>"
    return win

if __name__ == "__main__":
    app.run(debug=True)