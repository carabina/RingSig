//
//  RSA.swift
//  RingSig
//
//  Created by Fabio Tacke on 14.06.17.
//
//

import Foundation
import BigInt

class RSA {
  static func generateKeyPair(length: Int) -> KeyPair {
    // Choose two distinct prime numbers
    let p = BigUInt.randomPrime(length: length)
    var q = BigUInt.randomPrime(length: length)
    
    while p == q {
      q = BigUInt.randomPrime(length: length)
    }
    
    // Calculate modulus and private key d
    let n = p * q
    let phi = (p-1) * (q-1)
    let d = PublicKey.e.inverse(phi)!
    
    return KeyPair(privateKey: d, publicKey: PublicKey(n: n))
  }
  
  static func sign(message: BigUInt, privateKey: PrivateKey, publicKey: PublicKey) -> Signature {
    return message.power(privateKey, modulus: publicKey.n)
  }
  
  static func verify(message: BigUInt, signature: Signature, publicKey: PublicKey) -> Bool {
    return signature.power(PublicKey.e, modulus: publicKey.n) == message
  }
  
  struct KeyPair {
    let privateKey: PrivateKey
    let publicKey: PublicKey
  }
  
  struct PublicKey {
    let n: BigUInt
    static let e = BigUInt(65537)
  }
  
  typealias PrivateKey = BigUInt
  typealias Signature = BigUInt
}
